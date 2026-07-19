# create-jenkins-jobs.ps1
# Creates the two Inspire pipeline jobs in Jenkins via REST API
# Run from: C:\code\Inspire\TheTestTribe\InspireFranchises

$JenkinsUrl  = "http://localhost:8090"
$JobsDir     = ".\jenkins"

# ── Step 1: Establish session + get crumb ─────────────────────────────────────
Write-Host "Getting crumb..."
Invoke-WebRequest "$JenkinsUrl/crumbIssuer/api/json" -UseBasicParsing -SessionVariable sv | Out-Null
$crumbJson = (Invoke-WebRequest "$JenkinsUrl/crumbIssuer/api/json" -UseBasicParsing -WebSession $sv).Content | ConvertFrom-Json
$crumb = $crumbJson.crumb
Write-Host "Crumb: $crumb"

$headers = @{
    "Jenkins-Crumb" = $crumb
    "Content-Type"  = "application/xml"
}

# ── Step 2: Create Inspire-Arbys-Smoke ────────────────────────────────────────
Write-Host "`nCreating Inspire-Arbys-Smoke..."
$smokeXml = [System.IO.File]::ReadAllText("$JobsDir\job-smoke.xml")
try {
    $r = Invoke-WebRequest "$JenkinsUrl/createItem?name=Inspire-Arbys-Smoke" `
         -Method POST -Headers $headers -Body $smokeXml -UseBasicParsing -WebSession $sv
    Write-Host "  ✅ Created: HTTP $($r.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "  ⚠️  Already exists (HTTP 400) — skipping"
    } else {
        Write-Host "  ❌ Error: $($_.Exception.Message)"
    }
}

# ── Step 3: Create Inspire-Arbys-Full-Regression ──────────────────────────────
Write-Host "`nCreating Inspire-Arbys-Full-Regression..."
$fullXml = [System.IO.File]::ReadAllText("$JobsDir\job-full-regression.xml")
try {
    $r = Invoke-WebRequest "$JenkinsUrl/createItem?name=Inspire-Arbys-Full-Regression" `
         -Method POST -Headers $headers -Body $fullXml -UseBasicParsing -WebSession $sv
    Write-Host "  ✅ Created: HTTP $($r.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "  ⚠️  Already exists (HTTP 400) — skipping"
    } else {
        Write-Host "  ❌ Error: $($_.Exception.Message)"
    }
}

# ── Step 4: Verify ────────────────────────────────────────────────────────────
Write-Host "`nVerifying jobs on Jenkins dashboard..."
$jobs = (Invoke-WebRequest "$JenkinsUrl/api/json?tree=jobs[name,url]" -UseBasicParsing -WebSession $sv).Content | ConvertFrom-Json
$jobs.jobs | Format-Table name, url -AutoSize
