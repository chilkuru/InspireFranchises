# create-jenkins-jobs.ps1
# Creates the two Inspire pipeline jobs in Jenkins via REST API
# Run from: C:\code\Inspire\TheTestTribe\InspireFranchises

$JenkinsUrl  = "http://localhost:8090"
$JobsDir     = ".\jenkins"
# Note: Job XML configs use file:///workspace/InspireFranchises as the repo URL.
# This requires the project root to be mounted at /workspace/InspireFranchises
# in the Jenkins container (set in jenkins/docker-compose.yml).

# ---- GUARD: Ensure Jenkinsfile + job XMLs are committed before ANY job runs --------
# Why: Declarative Pipeline's parameters{} block overwrites job-level parameter
# choices on every build using whatever choices are in the checked-out Jenkinsfile.
# If the Jenkinsfile hasn't been committed, Jenkins uses the old version and
# resets the BRAND_PROFILE choices, dropping newly added brands.
#
# This check aborts the script when there are uncommitted changes to any of the
# files that define pipeline parameters, forcing the caller to commit first.
Write-Host "Checking git status for pipeline-critical files..."
$dirty = git status --porcelain Jenkinsfile jenkins\job-*.xml 2>&1
if ($dirty) {
    Write-Host ""
    Write-Host "  [ERROR] ABORT: The following pipeline-critical files have uncommitted changes:"
    $dirty | ForEach-Object { Write-Host "     $_" }
    Write-Host ""
    Write-Host "  Commit them first:  git add Jenkinsfile jenkins\job-*.xml ; git commit -m 'your message'"
    Write-Host "  Then re-run this script."
    exit 1
}
Write-Host "  [OK] All pipeline files are committed."

# ---- Step 1: Establish session + get crumb --------------------------------------------------------------------------
Write-Host "Getting crumb..."
Invoke-WebRequest "$JenkinsUrl/crumbIssuer/api/json" -UseBasicParsing -SessionVariable sv | Out-Null
$crumbJson = (Invoke-WebRequest "$JenkinsUrl/crumbIssuer/api/json" -UseBasicParsing -WebSession $sv).Content | ConvertFrom-Json
$crumb = $crumbJson.crumb
Write-Host "Crumb: $crumb"

$headers = @{
    "Jenkins-Crumb" = $crumb
    "Content-Type"  = "application/xml"
}

# ---- Step 2: Create Inspire-Arbys-Smoke --------------------------------------------------------------------------------
Write-Host "`nCreating Inspire-Arbys-Smoke..."
$smokeXml = [System.IO.File]::ReadAllText("$JobsDir\job-smoke.xml")
try {
    $r = Invoke-WebRequest "$JenkinsUrl/createItem?name=Inspire-Arbys-Smoke" `
         -Method POST -Headers $headers -Body $smokeXml -UseBasicParsing -WebSession $sv
    Write-Host "  [OK] Created: HTTP $($r.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "  [!]  Already exists (HTTP 400) -- skipping"
    } else {
        Write-Host "  [ERROR] Error: $($_.Exception.Message)"
    }
}

# ---- Step 3: Create Inspire-Arbys-Full-Regression ------------------------------------------------------------
Write-Host "`nCreating Inspire-Arbys-Full-Regression..."
$fullXml = [System.IO.File]::ReadAllText("$JobsDir\job-full-regression.xml")
try {
    $r = Invoke-WebRequest "$JenkinsUrl/createItem?name=Inspire-Arbys-Full-Regression" `
         -Method POST -Headers $headers -Body $fullXml -UseBasicParsing -WebSession $sv
    Write-Host "  [OK] Created: HTTP $($r.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "  [!]  Already exists (HTTP 400) -- skipping"
    } else {
        Write-Host "  [ERROR] Error: $($_.Exception.Message)"
    }
}

# ---- Step 4: Create Inspire-BaskinRobbins-Smoke ----------------------------------------------------------------
Write-Host "`nCreating Inspire-BaskinRobbins-Smoke..."
$brSmokeXml = [System.IO.File]::ReadAllText("$JobsDir\job-baskin-robbins-smoke.xml")
try {
    $r = Invoke-WebRequest "$JenkinsUrl/createItem?name=Inspire-BaskinRobbins-Smoke" `
         -Method POST -Headers $headers -Body $brSmokeXml -UseBasicParsing -WebSession $sv
    Write-Host "  [OK] Created: HTTP $($r.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "  [!]  Already exists (HTTP 400) -- skipping"
    } else {
        Write-Host "  [ERROR] Error: $($_.Exception.Message)"
    }
}

# ---- Step 5: Create Inspire-BaskinRobbins-Full-Regression --------------------------------------------
Write-Host "`nCreating Inspire-BaskinRobbins-Full-Regression..."
$brFullXml = [System.IO.File]::ReadAllText("$JobsDir\job-baskin-robbins-regression.xml")
try {
    $r = Invoke-WebRequest "$JenkinsUrl/createItem?name=Inspire-BaskinRobbins-Full-Regression" `
         -Method POST -Headers $headers -Body $brFullXml -UseBasicParsing -WebSession $sv
    Write-Host "  [OK] Created: HTTP $($r.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "  [!]  Already exists (HTTP 400) -- skipping"
    } else {
        Write-Host "  [ERROR] Error: $($_.Exception.Message)"
    }
}

# ---- Step 6: Sync BRAND_PROFILE choices on all jobs via Groovy --------------------------------
# Why: Even though each job XML has the correct choices, a pipeline run can
# overwrite them from the Jenkinsfile's parameters{} block. This Groovy call
# sets the choices to exactly what's in the Jenkinsfile -- making the live jobs
# authoritative immediately, independent of when the first build runs.
Write-Host "`nSyncing BRAND_PROFILE parameter choices on all jobs via Groovy script..."
$allBrands = @()
$jenkinsfileContent = Get-Content -Raw .\Jenkinsfile
if ($jenkinsfileContent -match 'choices:\s*\[([^\]]+)\]') {
    $rawBrands = $Matches[1] -split ","
    foreach ($b in $rawBrands) {
        $clean = $b.Trim().Trim("'").Trim()
        if ($clean -ne "") { $allBrands += $clean }
    }
    Write-Host "  Brands from Jenkinsfile: $($allBrands -join ', ')"
} else {
    Write-Host "  WARNING: Could not parse brands from Jenkinsfile -- using hardcoded fallback"
    $allBrands = @("arbys","baskin-robbins","all-brands")
}

# Build single-quoted Groovy list, e.g.: 'arbys','baskin-robbins','all-brands'
$brandListParts = @()
foreach ($b in $allBrands) { $brandListParts += "'$b'" }
$brandList = $brandListParts -join ","

# Groovy script stored in a temp file to avoid PowerShell string-parsing conflicts
$groovyTmp = [System.IO.Path]::GetTempFileName() + ".groovy"
$groovyCode  = "import jenkins.model.*; import hudson.model.*; "
$groovyCode += "def brands = [$brandList]; "
$groovyCode += "Jenkins.instance.items.each "
$groovyCode += "{ job -> def pd = job.getProperty(ParametersDefinitionProperty); "
$groovyCode += "if (!pd) return; "
$groovyCode += "pd.parameterDefinitions.each "
$groovyCode += "{ p -> if (p instanceof ChoiceParameterDefinition && p.name == 'BRAND_PROFILE') "
$groovyCode += "{ p.choices = brands; println('Updated ' + job.name) } }; "
$groovyCode += "job.save() }; println('Sync done')"
[System.IO.File]::WriteAllText($groovyTmp, $groovyCode, [System.Text.Encoding]::UTF8)
$body = "script=" + [Uri]::EscapeDataString([System.IO.File]::ReadAllText($groovyTmp))
Remove-Item $groovyTmp -Force -ErrorAction SilentlyContinue
$groovyHeaders = @{ "Jenkins-Crumb" = $crumb; "Content-Type" = "application/x-www-form-urlencoded" }
$gr = Invoke-WebRequest "$JenkinsUrl/scriptText" -Method POST -Headers $groovyHeaders -Body $body -UseBasicParsing -WebSession $sv
Write-Host $gr.Content

# ---- Step 7: Verify ------------------------------------------------------------------------------------------------------------------------
Write-Host "`nVerifying jobs on Jenkins dashboard..."
$jobs = (Invoke-WebRequest "$JenkinsUrl/api/json?tree=jobs[name,url]" -UseBasicParsing -WebSession $sv).Content | ConvertFrom-Json
$jobs.jobs | Format-Table name, url -AutoSize
