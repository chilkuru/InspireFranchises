# Generate-Presentation-v2.ps1
# Fixed: proper [Single] and [int] casts for all PowerPoint COM properties
# Run: powershell.exe -ExecutionPolicy Bypass -NonInteractive -File .\team-presentation\Generate-Presentation-v2.ps1

$outPath = "C:\code\Inspire\InspireFranchises\team-presentation\GitHub-Copilot-Custom-Agents.pptx"
$imgDir  = "C:\code\Inspire\InspireFranchises\team-presentation\extracted-images"

# --- Colours (BGR-packed integers as PowerPoint expects) ---
function RGB($r,$g,$b){ [int]($r*65536 + $g*256 + $b) }
$cNavy  = RGB  13  27  42
$cCard  = RGB  26  39  64
$cDark  = RGB  14  24  38
$cGold  = RGB 245 166  35
$cBlue  = RGB  74 158 255
$cGreen = RGB  62 207 142
$cWhite = RGB 232 237 245
$cMuted = RGB 122 146 176
$cBorder= RGB  36  52  80
$cBlack = RGB   0   0   0
$cBg2   = RGB  13  27  50   # title slide bg

# --- PowerPoint constants ---
$msoTrue  = [int]-1
$msoFalse = [int]0
$ppSave   = [int]24  # ppSaveAsOpenXMLPresentation
$ppLayoutBlank = [int]12
$ppAlignLeft   = [int]1
$ppAlignCenter = [int]2
$ppAlignRight  = [int]3

# --- Add text box helper ---
# All numeric args explicitly cast to avoid COM type errors
function Add-TB {
    param($slide, [string]$text,
          [Single]$l, [Single]$t, [Single]$w, [Single]$h,
          [Single]$sz, [int]$col,
          [int]$bold=0, [int]$align=1, [string]$font="Segoe UI")
    $tb = $slide.Shapes.AddTextbox([int]1, $l, $t, $w, $h)
    $tf = $tb.TextFrame
    $tf.WordWrap  = $msoTrue
    $tf.AutoSize  = $msoFalse
    $tr = $tf.TextRange
    $tr.Text = $text
    $tr.Font.Size        = $sz
    $tr.Font.Color.RGB   = $col
    $tr.Font.Bold        = $bold
    $tr.Font.Name        = $font
    $tr.ParagraphFormat.Alignment = $align
    $tb.Line.Visible     = $msoFalse
    return $tb
}

# --- Add filled rectangle helper ---
function Add-Rect {
    param($slide, [Single]$l, [Single]$t, [Single]$w, [Single]$h,
          [int]$fill, [int]$border=0)
    $r = $slide.Shapes.AddShape([int]1, $l, $t, $w, $h)
    $r.Fill.ForeColor.RGB = $fill
    $r.Fill.Solid()
    if ($border) {
        $r.Line.Visible         = $msoTrue
        $r.Line.ForeColor.RGB   = $cBorder
        $r.Line.Weight          = 0.5
    } else {
        $r.Line.Visible = $msoFalse
    }
    return $r
}

# --- New slide helper ---
function New-Slide { param($pres, [int]$num)
    $sl = $pres.Slides.Add($num, $ppLayoutBlank)
    # Remove auto-generated placeholder if present
    while ($sl.Shapes.Count -gt 0) {
        try { $sl.Shapes.Item(1).Delete() } catch { break }
    }
    $sl.Background.Fill.ForeColor.RGB = $cNavy
    $sl.Background.Fill.Solid()
    # Gold accent bar at top
    Add-Rect $sl 0 0 720 3 $cGold | Out-Null
    # Footer text
    Add-TB $sl "GitHub Copilot x Inspire Brands QE" `
        0 393 720 12 7 $cBorder `
        0 $ppAlignCenter | Out-Null
    return $sl
}

# ==========================================================
Write-Host "Launching PowerPoint..."
$ppt = New-Object -ComObject PowerPoint.Application
$ppt.Visible = $msoTrue
Start-Sleep -Milliseconds 1500
$pres = $ppt.Presentations.Add($msoTrue)
$pres.PageSetup.SlideWidth  = 720
$pres.PageSetup.SlideHeight = 405
Start-Sleep -Milliseconds 500
Write-Host "Initial slides: $($pres.Slides.Count)"

# ==========================================================
# SLIDE 01 â€” TITLE
# ==========================================================
Write-Host "Building Slide 01..."
$s = New-Slide $pres 1
$s.Background.Fill.ForeColor.RGB = $cBg2
$s.Background.Fill.Solid()
Add-Rect $s 0   0   720 3   $cGold | Out-Null
Add-Rect $s 320 152 80  3   $cGold | Out-Null
Add-TB $s "INSPIRE BRANDS  .  QUALITY ENGINEERING" `
    60 62 600 18 9 $cGold 1 $ppAlignCenter | Out-Null
Add-TB $s "GitHub Copilot for Automation Frameworks" `
    60 84 600 60 28 $cWhite 1 $ppAlignCenter | Out-Null
Add-TB $s "From writing test code to building intelligent, self-documenting frameworks" `
    80 162 560 20 10 $cMuted 0 $ppAlignCenter | Out-Null
Add-TB $s "how AI-assisted development changes the game for QE teams." `
    80 183 560 18 10 $cMuted 0 $ppAlignCenter | Out-Null
$pxs = @("Agent Mode","Custom Agents","Selenium + TestNG","Inspire Framework")
$px = 88
foreach ($p in $pxs) {
    Add-Rect $s $px 210 130 22 (RGB 18 36 64) 1 | Out-Null
    Add-TB $s $p $px 210 130 22 8 $cBlue 1 $ppAlignCenter | Out-Null
    $px = $px + 136
}
Add-TB $s "GitHub Copilot x Inspire Brands QE" `
    0 393 720 12 7 $cBorder 0 $ppAlignCenter | Out-Null

# ==========================================================
# SLIDE 02 â€” WHY COPILOT
# ==========================================================
Write-Host "Building Slide 02..."
$s = New-Slide $pres 2
Add-TB $s "Why GitHub Copilot for Automation Frameworks?" `
    20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
$cards2 = @(
    @{t="Accelerate Development";x=20;y=42;
      b="Generate Page Object classes from a URL in seconds`nAuto-complete @FindBy locators using site context`nScaffold new brand test classes from existing patterns`nReduce boilerplate from hours to minutes"},
    @{t="Understand the Codebase";x=370;y=42;
      b="Ask questions about any class without reading it`nNavigate complex inheritance chains instantly`nExplain why a test is failing with context`nOnboard new team members in minutes, not days"},
    @{t="Keeps Code Inside Your Org";x=20;y=210;
      b="Runs inside VS Code - code stays on your machine`nRespects corporate network and security policies`nGitHub Enterprise support for air-gapped environments`nNo external calls with proprietary test code"},
    @{t="Enforces Team Standards";x=370;y=210;
      b="Custom agents encode your specific project rules`nConsistent patterns across all developers and brands`nPrevents re-discovery of already-solved problems`nHard-won fixes become permanent team knowledge"}
)
foreach ($c in $cards2) {
    Add-Rect $s $c.x $c.y 340 155 $cCard 1 | Out-Null
    Add-TB $s $c.t ($c.x+10) ($c.y+8) 320 16 10 $cGold 1 | Out-Null
    Add-TB $s $c.b ($c.x+10) ($c.y+28) 320 115 9 $cMuted | Out-Null
}

# ==========================================================
# SLIDE 03 â€” VS CURSOR
# ==========================================================
Write-Host "Building Slide 03..."
$s = New-Slide $pres 3
Add-TB $s "GitHub Copilot vs Cursor IDE" 20 12 560 20 13 $cWhite 1 | Out-Null
Add-TB $s "For Enterprise QE Teams" 580 16 120 14 8 $cMuted 0 $ppAlignRight | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
$rows3 = @(
    @{d="IDE Integration";           c="Runs inside VS Code - no context switch";   r="Separate fork of VS Code"},
    @{d="Enterprise Security";       c="GitHub Enterprise + SSO + audit logs";      r="Business plan; limited controls"},
    @{d="Custom Agents";             c=".agent.md files committed to the repo";     r="Rules files, no agent concept"},
    @{d="Team Knowledge Sharing";    c="Agent in Git - everyone uses same rules";   r="Per-developer settings only"},
    @{d="Automation-Specific Tools"; c="runTests, testFailure, browser tools";      r="Generic code tools only"},
    @{d="Cost per developer";        c="USD 19/mo - bundled with GitHub";           r="USD 20/mo - separate vendor"},
    @{d="Licensing";                 c="Already in GitHub org - no new vendor";     r="New vendor relationship required"}
)
$ry3 = 40
Add-Rect $s 20 $ry3 200 20 $cCard | Out-Null
Add-TB $s "Dimension" 22 ($ry3+3) 196 14 9 $cGold 1 | Out-Null
Add-Rect $s 222 $ry3 240 20 $cCard | Out-Null
Add-TB $s "GitHub Copilot" 224 ($ry3+3) 236 14 9 $cGold 1 | Out-Null
Add-Rect $s 464 $ry3 236 20 $cCard | Out-Null
Add-TB $s "Cursor IDE" 466 ($ry3+3) 232 14 9 $cGold 1 | Out-Null
$ry3 = $ry3 + 22
foreach ($r in $rows3) {
    Add-Rect $s 20  $ry3 200 34 (RGB 18 28 45) 1 | Out-Null
    Add-Rect $s 222 $ry3 240 34 (RGB 14 32 22) 1 | Out-Null
    Add-Rect $s 464 $ry3 236 34 (RGB 28 22 30) 1 | Out-Null
    Add-TB $s $r.d 22 ($ry3+5) 196 24 8 $cWhite 1 | Out-Null
    Add-TB $s $r.c 224 ($ry3+5) 236 24 8 $cGreen | Out-Null
    Add-TB $s $r.r 466 ($ry3+5) 232 24 8 $cMuted | Out-Null
    $ry3 = $ry3 + 36
}

# ==========================================================
# SLIDE 04 â€” THREE MODES
# ==========================================================
Write-Host "Building Slide 04..."
$s = New-Slide $pres 4
Add-TB $s "GitHub Copilot - Three Interaction Modes" `
    20 12 580 20 13 $cWhite 1 | Out-Null
Add-TB $s "Ctrl+Shift+I" 610 16 100 14 8 $cMuted 0 $ppAlignRight | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null

# Mode cards
$modes4 = @(
    @{tag="ASK";   col=$cBlue;  x=20;
      t="Ask Mode";
      b="Conversational Q and A about your code`nExplains classes, methods, errors`nAnswers WITHOUT making any changes`nBest for: understanding and learning`n`nExample: What does AbstractBrandPage do?"},
    @{tag="PLAN";  col=$cGold;  x=254;
      t="Plan Mode";
      b="Researches and outlines multi-step tasks`nShows what it WOULD do before acting`nReview proposed changes before applying`nBest for: complex refactoring, new features`n`nExample: Plan how to add Baskin Robbins brand"},
    @{tag="AGENT"; col=$cGreen; x=488;
      t="Agent Mode";
      b="Autonomously reads, edits and runs code`nUses tools: terminal, browser, file system`nIterates until the task is complete`nBest for: end-to-end automation tasks`n`nExample: Add Baskin Robbins brand to the framework"}
)
foreach ($m in $modes4) {
    Add-Rect $s $m.x 42 224 212 $cCard 1 | Out-Null
    Add-Rect $s $m.x 42 224 3 $m.col | Out-Null   # top accent
    Add-Rect $s ($m.x+8) 54 46 14 $cDark 1 | Out-Null
    Add-TB $s $m.tag ($m.x+8) 54 46 14 7 $m.col 1 $ppAlignCenter | Out-Null
    Add-TB $s $m.t  ($m.x+8) 72 208 16 12 $cWhite 1 | Out-Null
    Add-TB $s $m.b  ($m.x+8) 92 208 154 8 $cMuted | Out-Null
}
# Screenshot image1.png showing mode picker
$s.Shapes.AddPicture("$imgDir\image1.png",$msoFalse,$msoTrue,20,262,680,52) | Out-Null
Add-Rect $s 20 260 680 52 (RGB 14 28 52) 1 | Out-Null  # dim overlay
$s.Shapes.AddPicture("$imgDir\image1.png",$msoFalse,$msoTrue,120,263,480,48) | Out-Null
Add-TB $s "VS Code - actual Copilot mode picker (@ shortcut)" `
    0 316 720 12 7 $cMuted 0 $ppAlignCenter | Out-Null

# ==========================================================
# SLIDE 05 â€” AGENT MODE DEEP DIVE
# ==========================================================
Write-Host "Building Slide 05..."
$s = New-Slide $pres 5
Add-TB $s "Deep Dive - Agent Mode" 20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
$c5 = @(
    @{t="How Agent Mode Works";     x=20;  y=42;  w=330;
      b="Receives your task in natural language`nReads relevant files across your workspace`nMakes edits, runs terminal commands, runs tests`nReads output and iterates if something fails`nContinues until the task succeeds"},
    @{t="Tools It Can Use";         x=370; y=42;  w=330;
      b="File system: read, create, edit, rename files`nTerminal: run Maven, compile, execute tests`nBrowser: open pages, take screenshots`nSemantic search across your entire codebase`nTest runner: run tests, read results inline"},
    @{t="What Makes It Different";  x=20;  y=200; w=330;
      b="Not just code completion - it ACTS autonomously`nMulti-step reasoning across many files at once`nSelf-correcting: reads errors and fixes them`nCombines read plus edit plus execute in one loop"},
    @{t="Real Example - Inspire Framework"; x=370; y=200; w=330;
      b="Prompt: Add Dunkin brand to the framework`n`nAgent automatically:`n  Creates DunkinPage.java with correct @FindBy`n  Adds case DUNKIN: in BrandPageFactory.java`n  Creates DunkinTest.java + testng-dunkin.xml`n  Runs smoke tests to verify - PASS"}
)
foreach ($c in $c5) {
    Add-Rect $s $c.x $c.y $c.w 148 $cCard 1 | Out-Null
    Add-TB $s $c.t ($c.x+10) ($c.y+8) ($c.w-20) 16 10 $cGold 1 | Out-Null
    Add-TB $s $c.b ($c.x+10) ($c.y+28) ($c.w-20) 112 8 $cMuted | Out-Null
}

# ==========================================================
# SLIDE 06 â€” CREATE CUSTOM AGENTS
# ==========================================================
Write-Host "Building Slide 06..."
$s = New-Slide $pres 6
Add-TB $s "How to Create a Custom GitHub Copilot Agent" `
    20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
# Step flow
$steps6 = @(
    @{n="1";t="Open Agent Picker";  b="Press @ or click Agent button then Configure Custom Agents"},
    @{n="2";t="Create New Agent";   b="Click + Create new custom agent in the picker"},
    @{n="3";t="Choose Location";    b=".github/agents/ (default) shared via Git with the team"},
    @{n="4";t="Fill the Template";  b="Edit the .agent.md with YAML frontmatter + instructions"},
    @{n="5";t="Commit and Share";   b="git push - all teammates get the agent immediately"}
)
$sx6 = 20; $sw6 = 133
foreach ($st in $steps6) {
    Add-Rect $s $sx6 42 $sw6 68 $cCard 1 | Out-Null
    $nc = Add-Rect $s ($sx6+44) 48 26 26 $cGold; $nc.Line.Visible=$msoFalse
    Add-TB $s $st.n ($sx6+44) 48 26 26 12 $cBlack 1 $ppAlignCenter | Out-Null
    Add-TB $s $st.t ($sx6+4) 78 ($sw6-8) 12 8 $cWhite 1 $ppAlignCenter | Out-Null
    Add-TB $s $st.b ($sx6+4) 92 ($sw6-8) 16 7 $cMuted 0 $ppAlignCenter | Out-Null
    $sx6 = $sx6 + $sw6 + 2
}
# Screenshots (image2 = Configure dialog, image3 = location picker, image4 = template)
$s.Shapes.AddPicture("$imgDir\image2.png",$msoFalse,$msoTrue,18,118,342,80)  | Out-Null
$s.Shapes.AddPicture("$imgDir\image3.png",$msoFalse,$msoTrue,18,204,342,50)  | Out-Null
$s.Shapes.AddPicture("$imgDir\image4.png",$msoFalse,$msoTrue,366,118,334,228) | Out-Null
Add-TB $s "Step 2 - Configure dialog" 18 108 200 10 7 $cGold 1 | Out-Null
Add-TB $s "Step 3 - Location picker" 18 194 200 10 7 $cGold 1 | Out-Null
Add-TB $s "Step 4 - Template in VS Code" 366 108 250 10 7 $cGold 1 | Out-Null

# ==========================================================
# SLIDE 07 â€” AGENT COMPONENTS
# ==========================================================
Write-Host "Building Slide 07..."
$s = New-Slide $pres 7
Add-TB $s "Necessary Components of a Custom Agent File" `
    20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
$comps7 = @(
    @{t="YAML Frontmatter (Required)"; x=20;  y=42;
      b="name, description, tools list, argument-hint`nDeclares the agent identity and permissions`nUsers see permissions before running the agent"},
    @{t="Tools Permissions";           x=240; y=42;
      b="Explicitly declare only what the agent needs`nGroups: vscode, execute, read, edit, search, web`nPrinciple of least privilege - nothing extra"},
    @{t="Mandatory Rules Section";     x=460; y=42;
      b="NEVER-break rules in ALL-CAPS headers`nExamples: always clean test, never use text()`nEnforced on every single Copilot response"},
    @{t="Project Structure Tree";      x=20;  y=190;
      b="Full file tree with inline annotations per file`nTells agent what each file is responsible for`nPrevents wrong-file edits and hallucinations"},
    @{t="Pitfalls and Solutions";      x=240; y=190;
      b="Documents every hard-won bug: root cause + fix`nPrevents team re-discovering same issues`nNumbered P-01 to P-N for easy reference"},
    @{t="Agent Behaviour Rules";       x=460; y=190;
      b="Numbered constraints for every code-gen action`nXPath rules, screenshot rules, brand extension rules`nSame quality output from every developer"}
)
foreach ($c in $comps7) {
    Add-Rect $s $c.x $c.y 218 138 $cCard 1 | Out-Null
    Add-TB $s $c.t ($c.x+8) ($c.y+8) 200 18 10 $cGold 1 | Out-Null
    Add-TB $s $c.b ($c.x+8) ($c.y+30) 200 100 8 $cMuted | Out-Null
}

# ==========================================================
# SLIDE 08 â€” TOOLS
# ==========================================================
Write-Host "Building Slide 08..."
$s = New-Slide $pres 8
Add-TB $s "Tools in the Inspire Agent - What Each Enables" `
    20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
$tools8 = @(
    @{t="vscode/* - IDE Integration";  x=20;  y=42;
      b="installExtension - auto-install Java Pack on clone`nmemory - remember clean already ran this session`nrunCommand - Java: Clean Workspace for stale bytecode`naskQuestions - Which brand are you adding?"},
    @{t="execute/* - Test Execution";   x=250; y=42;
      b="runInTerminal - .\mvnw.cmd clean test -P arbys`nrunTests - trigger play button per test method`ntestFailure - read stack traces from last run`ngetTerminalOutput - parse PASSED/FAILED counts"},
    @{t="read/* - Inspection";          x=480; y=42;
      b="readFile - read any Java/XML/properties file`nproblems - see compile errors in Problems panel`nterminalLastCommand - was clean already run?"},
    @{t="edit/* - Code Generation";     x=20;  y=200;
      b="createFile - DunkinPage.java, DunkinTest.java`neditFiles - add case DUNKIN: to BrandPageFactory`ncreateDirectory - create package directories"},
    @{t="search/* - Navigation";        x=250; y=200;
      b="codebase - where is cookie banner handled?`ntextSearch - find all text() locators to fix`nusages - who calls isVisibleAfterWait()?`nchanges - git diff since last run"},
    @{t="web/* and agent/*";            x=480; y=200;
      b="web/fetch - inspect live page DOM for locators`nbrowser/openBrowserPage - open Extent report`nagent/runSubagent - delegate complex tasks`ntodo - track multi-step task progress"}
)
foreach ($t in $tools8) {
    Add-Rect $s $t.x $t.y 228 150 $cCard 1 | Out-Null
    Add-TB $s $t.t ($t.x+8) ($t.y+8) 210 16 10 $cGold 1 | Out-Null
    Add-TB $s $t.b ($t.x+8) ($t.y+28) 210 114 8 $cMuted | Out-Null
}
# Screenshot: image6.png - tools table
$s.Shapes.AddPicture("$imgDir\image6.png",$msoFalse,$msoTrue,20,356,680,36) | Out-Null

# ==========================================================
# SLIDE 09 â€” AGENT SECTIONS
# ==========================================================
Write-Host "Building Slide 09..."
$s = New-Slide $pres 9
Add-TB $s "Key Sections in the Inspire Franchise Agent" `
    20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
# Table header
Add-Rect $s 20 40 288 18 $cCard | Out-Null
Add-Rect $s 310 40 216 18 $cCard | Out-Null
Add-Rect $s 528 40 172 18 $cCard | Out-Null
Add-TB $s "Section"       22 43 284 14 9 $cBlue 1 | Out-Null
Add-TB $s "Contains"      312 43 212 14 9 $cBlue 1 | Out-Null
Add-TB $s "Why It Matters" `
    530 43 168 14 9 $cBlue 1 | Out-Null
$secs9 = @(
    @{s="MANDATORY Rules x3";      c="clean test always, cookie banner, 5 XPath rules";     w="Prevents the most common failures"},
    @{s="Project Structure";       c="Full file tree with inline annotations";               w="Agent edits the right file always"},
    @{s="Brands Table";            c="7 brands: enum, URL slug, properties file";            w="Correct names and paths for all brands"},
    @{s="Test Case Conventions";   c="TC prefix map, naming pattern, valid groups";          w="Consistent IDs without a stale registry"},
    @{s="Design Patterns + SOLID"; c="9 patterns mapped to exact classes";                   w="New code follows same architecture"},
    @{s="Add New Brand (4 Steps)"; c="Copy-paste ready code for each step";                  w="New brand in 5 mins, zero existing changes"},
    @{s="Pitfalls P-01 to P-10";   c="Root cause + fix for every hard-won bug";              w="No developer rediscovers the same issue"},
    @{s="Agent Behaviour Rules";   c="10 numbered constraints for code generation";          w="Same quality from every developer"}
)
$ry9 = 60
foreach ($r in $secs9) {
    Add-Rect $s 20  $ry9 288 32 (RGB 18 28 45) 1 | Out-Null
    Add-Rect $s 310 $ry9 216 32 $cDark 1 | Out-Null
    Add-Rect $s 528 $ry9 172 32 $cDark 1 | Out-Null
    Add-TB $s $r.s 22 ($ry9+5) 284 22 8 $cWhite 1 | Out-Null
    Add-TB $s $r.c 312 ($ry9+5) 212 22 7 $cMuted | Out-Null
    Add-TB $s $r.w 530 ($ry9+5) 168 22 7 $cGreen | Out-Null
    $ry9 = $ry9 + 34
}
# Screenshot: image5.png - Inspire agent in picker
$s.Shapes.AddPicture("$imgDir\image5.png",$msoFalse,$msoTrue,530,60,170,272) | Out-Null

# ==========================================================
# SLIDE 10 â€” DEMO
# ==========================================================
Write-Host "Building Slide 10..."
$s = New-Slide $pres 10
Add-TB $s "Demo - Select Agent and Add Baskin Robbins Brand" `
    20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
Add-TB $s "PART 1 - Selecting the Custom Agent" 24 40 330 14 8 $cGold 1 | Out-Null
$p1 = @(
    @{n="1";t="Open Copilot Chat";          b="Press Ctrl+Shift+I or click the Copilot icon in sidebar"},
    @{n="2";t="Click the Agent Picker";     b="Type @ or click the Agent button at bottom of chat panel"},
    @{n="3";t="Select the Inspire Agent";   b="Choose Inspire-Franchise-Selenium-Automation-Framework-Agent"},
    @{n="4";t="Agent is Active";            b="Agent name in chat header. All framework rules pre-loaded."}
)
$sy10 = 56
foreach ($st in $p1) {
    $nb = Add-Rect $s 24 ($sy10+1) 20 20 $cGold; $nb.Line.Visible=$msoFalse
    Add-TB $s $st.n 24 ($sy10+1) 20 20 9 $cBlack 1 $ppAlignCenter | Out-Null
    Add-TB $s $st.t 48 ($sy10+1) 280 12 9 $cWhite 1 | Out-Null
    Add-TB $s $st.b 48 ($sy10+14) 280 12 8 $cMuted | Out-Null
    Add-Rect $s 20 ($sy10+30) 330 1 $cBorder | Out-Null
    $sy10 = $sy10 + 34
}
Add-TB $s "PART 2 - Add Baskin Robbins Brand" 370 40 330 14 8 $cGold 1 | Out-Null
$p2 = @(
    @{n="5";t="Type the Request";          b="Add Baskin Robbins brand to this framework"},
    @{n="6";t="Agent Creates 4 Files";     b="BaskinRobbinsPage.java + BrandPageFactory case + BaskinRobbinsTest.java + testng XML"},
    @{n="7";t="Agent Runs Smoke Tests";    b=".\mvnw.cmd clean test -P baskin-robbins -Dgroups=smoke - all TC-B tests PASS"}
)
$sy10b = 56
foreach ($st in $p2) {
    $nb2 = Add-Rect $s 370 ($sy10b+1) 20 20 $cGold; $nb2.Line.Visible=$msoFalse
    Add-TB $s $st.n 370 ($sy10b+1) 20 20 9 $cBlack 1 $ppAlignCenter | Out-Null
    Add-TB $s $st.t 394 ($sy10b+1) 280 12 9 $cWhite 1 | Out-Null
    Add-TB $s $st.b 394 ($sy10b+14) 280 16 8 $cMuted | Out-Null
    Add-Rect $s 366 ($sy10b+34) 334 1 $cBorder | Out-Null
    $sy10b = $sy10b + 40
}
Add-Rect $s 20 226 680 36 (RGB 14 28 52) 1 | Out-Null
Add-TB $s "The 12 common TC-B brand tests run automatically for Baskin Robbins - zero code duplication. Open/Closed Principle." `
    28 230 664 28 9 $cWhite | Out-Null

# ==========================================================
# SLIDE 11 â€” KEY TAKEAWAYS
# ==========================================================
Write-Host "Building Slide 11..."
$s = New-Slide $pres 11
Add-TB $s "Key Takeaways" 20 12 680 20 13 $cWhite 1 | Out-Null
Add-Rect $s 20 34 680 1 $cBorder | Out-Null
$takes = @(
    @{t="Speed";                  x=20;
      b="A new brand that took a day now takes 5 minutes with the custom agent."},
    @{t="Consistency";            x=254;
      b="Every developer produces the same quality output - patterns and rules always applied."},
    @{t="Knowledge Preservation"; x=488;
      b="Every hard-won fix is permanently encoded. No one rediscovers the same bug twice."}
)
foreach ($tk in $takes) {
    Add-Rect $s $tk.x 42 224 120 $cCard 1 | Out-Null
    Add-TB $s $tk.t ($tk.x+10) 50 204 18 12 $cGold 1 | Out-Null
    Add-TB $s $tk.b ($tk.x+10) 72 204 82 9 $cMuted | Out-Null
}
Add-Rect $s 20 172 680 70 (RGB 14 30 58) 1 | Out-Null
Add-Rect $s 20 172 4   70 $cGold | Out-Null
Add-TB $s "The custom agent is not just a productivity tool - it is a living document of your team's collective intelligence." `
    32 176 660 28 10 $cWhite 1 | Out-Null
Add-TB $s "The .agent.md lives in .github/agents/, committed to Git. Every team member who clones the repo gets the same expert-level Copilot experience." `
    32 206 660 28 9 $cWhite | Out-Null
Add-TB $s "Inspire-Franchise-Selenium-Automation-Framework-Agent  |  .\mvnw.cmd clean test -P arbys  |  Zero existing files modified when adding a brand" `
    20 252 680 14 7 $cMuted 0 $ppAlignCenter | Out-Null

# ==========================================================
# SAVE
# ==========================================================
Write-Host "Saving to: $outPath"
$pres.SaveAs($outPath, $ppSave)
$pres.Close()
$ppt.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ppt) | Out-Null
[System.GC]::Collect()
$kb = [math]::Round((Get-Item $outPath).Length/1KB,1)
Write-Host "DONE - PPTX: $kb KB"

