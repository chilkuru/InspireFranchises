# Inspire Brands Franchising — Selenium Automation Framework

A production-grade, modular Selenium 4 + TestNG automation framework for  
[https://www.franchising.inspirebrands.com](https://www.franchising.inspirebrands.com).

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Design Patterns & SOLID Principles](#design-patterns--solid-principles)
4. [Test Cases](#test-cases)
5. [Prerequisites](#prerequisites)
6. [Running Tests](#running-tests)
7. [Adding a New Brand](#adding-a-new-brand)
8. [Reports](#reports)
9. [TestLink & Jenkins Orchestration](#testlink--jenkins-orchestration)
10. [Configuration Reference](#configuration-reference)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│  TestNG Suite XML  (testng-suites/)                             │
│    ├── testng-all.xml      – All tests                          │
│    └── testng-arbys.xml    – Arby's only                        │
├─────────────────────────────────────────────────────────────────┤
│  Test Layer  (src/test/java/com/inspire/tests/)                 │
│    ├── HomePageTest                                             │
│    └── brands/                                                  │
│        ├── AbstractBrandTest   ← common TC-B-01..TC-B-12        │
│        └── ArbysTest           ← TC-A-01..TC-A-11               │
├─────────────────────────────────────────────────────────────────┤
│  Page Object Layer  (src/main/java/com/inspire/pages/)          │
│    ├── HomePage              (implements INavigable)            │
│    └── brands/                                                  │
│        ├── AbstractBrandPage  (implements IBrandPage)           │
│        └── ArbysPage                                            │
├─────────────────────────────────────────────────────────────────┤
│  Factory  BrandPageFactory  →  creates page objects by Brand    │
├─────────────────────────────────────────────────────────────────┤
│  Infrastructure                                                  │
│    ├── DriverManager    – ThreadLocal WebDriver (Chrome/FF/Edge) │
│    ├── ConfigReader     – Singleton; merges config + brand props │
│    ├── ExtentReportManager – HTML report (Extent Spark)         │
│    ├── WaitUtils        – explicit-wait helpers                  │
│    └── ScreenshotUtils  – on-failure screenshots                │
├─────────────────────────────────────────────────────────────────┤
│  Config  (src/test/resources/)                                   │
│    ├── config.properties        – global settings               │
│    └── brands/<brand>.properties – per-brand overrides          │
└─────────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
InspireFranchises/
├── pom.xml
├── testng-suites/
│   ├── testng-all.xml
│   └── testng-arbys.xml
├── src/
│   ├── main/java/com/inspire/
│   │   ├── base/
│   │   │   ├── BasePage.java          # PageFactory init + helpers
│   │   │   └── BaseTest.java          # TestNG lifecycle + Extent hooks
│   │   ├── config/
│   │   │   └── ConfigReader.java      # Singleton config reader
│   │   ├── constants/
│   │   │   └── AppConstants.java      # URL / text / timeout constants
│   │   ├── driver/
│   │   │   └── DriverManager.java     # ThreadLocal WebDriver
│   │   ├── enums/
│   │   │   └── Brand.java             # All supported brands
│   │   ├── factory/
│   │   │   └── BrandPageFactory.java  # Creates page objects by brand
│   │   ├── interfaces/
│   │   │   ├── IBrandPage.java        # Common brand-page contract
│   │   │   └── INavigable.java        # Navigation contract
│   │   ├── listeners/
│   │   │   └── ExtentReportListener.java
│   │   ├── pages/
│   │   │   ├── HomePage.java
│   │   │   └── brands/
│   │   │       ├── AbstractBrandPage.java
│   │   │       └── ArbysPage.java
│   │   └── utils/
│   │       ├── ExtentReportManager.java
│   │       ├── ScreenshotUtils.java
│   │       └── WaitUtils.java
│   └── test/
│       ├── java/com/inspire/tests/
│       │   ├── HomePageTest.java
│       │   └── brands/
│       │       ├── AbstractBrandTest.java
│       │       └── ArbysTest.java
│       └── resources/
│           ├── config.properties
│           ├── log4j2.xml
│           └── brands/
│               ├── arbys.properties
│               ├── baskin-robbins.properties
│               ├── buffalo-wild-wings.properties
│               ├── bww-go.properties
│               ├── dunkin.properties
│               ├── jimmy-johns.properties
│               └── sonic.properties
└── test-output/             # generated – gitignored
    ├── extent-reports/
    ├── screenshots/
    └── logs/
```

---

## Design Patterns & SOLID Principles

| Pattern / Principle | Where Applied |
|---|---|
| **Page Factory** | `@FindBy` locators in all `*Page` classes; `PageFactory.initElements()` in `BasePage` |
| **Factory Pattern** | `BrandPageFactory.create(Brand, WebDriver)` decouples callers from concrete page types |
| **Singleton** | `ConfigReader`, `ExtentReportManager` — one instance shared by all threads |
| **Template Method** | `AbstractBrandTest.getBrandPage()` — concrete brand test classes provide their page |
| **ThreadLocal** | `DriverManager` — safe WebDriver per-thread for parallel execution |
| **S** – Single Responsibility | Each class does one thing: Driver lifecycle, Config reading, Page interactions, Reporting |
| **O** – Open/Closed | Add a brand by creating a new `*Page` + enum entry + properties file; nothing else changes |
| **L** – Liskov Substitution | `ArbysPage` is used wherever `AbstractBrandPage` / `IBrandPage` is expected |
| **I** – Interface Segregation | `IBrandPage` and `INavigable` are focused; page classes implement only what they need |
| **D** – Dependency Inversion | Tests depend on `IBrandPage` abstraction; `BrandPageFactory` provides the concrete type |

---

## Test Cases

### Home Page (TC-H-01 … TC-H-11)

| TC ID | Description | Group |
|---|---|---|
| TC-H-01 | Home page loads at correct URL | smoke |
| TC-H-02 | Hero heading "Anything is Possible" displayed | smoke |
| TC-H-03 | Hero heading text matches expected value | regression |
| TC-H-04 | Hero "GET STARTED" CTA button displayed | smoke |
| TC-H-05 | "GET STARTED" navigates to `/franchise-with-us` | smoke |
| TC-H-06 | "Grow with Inspire's Iconic Brands" section displayed | regression |
| TC-H-07 | "Our Brands" dropdown contains Arby's | regression |
| TC-H-08 | Arby's body link navigates to `/arbys` | regression |
| TC-H-09 | Footer displayed with company name | regression |
| TC-H-10 | LinkedIn link present in footer | regression |
| TC-H-11 | "How do I become a franchisee?" section displayed | regression |

### Common Brand Page (TC-B-01, TC-B-03) — inherited by every brand test class

Two focused smoke checks kept deliberately minimal so that any brand suite
(`-P arbys`, `-P dunkin`, etc.) runs fast. Deeper section/footer/navigation
coverage lives in brand-specific test classes.

| TC ID | Description | Group |
|---|---|---|
| TC-B-01 | Brand page loads at correct URL | smoke |
| TC-B-03 | Hero "GET STARTED" CTA button displayed | smoke |

### Arby's-Specific (TC-A-01 … TC-A-11)

| TC ID | Description | Group |
|---|---|---|
| TC-A-01 | Page title contains "Arby's" | smoke |
| TC-A-02 | Hero heading reads "Franchise with Arby's" | smoke |
| TC-A-03 | "Why Arby's?" heading displayed | regression |
| TC-A-04 | All three awards (Entrepreneur, Top Food, Franchise 500) displayed | regression |
| TC-A-05 | "We Have The Meats" tagline displayed | regression |
| TC-A-06 | $500,000 liquid assets requirement displayed | regression |
| TC-A-07 | $1,000,000 net worth requirement displayed | regression |
| TC-A-08 | All three formats (Free Standing, Endcap, Small Format) displayed | regression |
| TC-A-09 | GET STARTED URL contains Arby's brand parameter | regression |
| TC-A-10 | "Anything is possible with Arby's" section displayed | regression |
| TC-A-11 | "3,500 restaurants" factoid displayed | regression |

**Total: 24 test cases** (11 home + 2 common brand + 11 Arby's-specific)

---

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Java JDK | **21** | Set `JAVA_HOME`; Temurin 21 recommended — https://adoptium.net |
| Chrome | Latest stable | WebDriverManager auto-downloads the matching ChromeDriver |
| Maven | Not required | The Maven Wrapper (`mvnw.cmd`) downloads Maven 3.9.9 automatically on first run |
| Internet access | — | Tests hit the live site `franchising.inspirebrands.com` |
| Docker Desktop | Latest | Required only for TestLink + Jenkins — not needed for local test runs |

---

## Running Tests

> **Windows**: Always use `.\mvnw.cmd` — Maven is not required to be installed.  
> **Linux/macOS**: Use `./mvnw`. The wrapper downloads Maven 3.9.9 automatically on first run.  
> Always include `clean` — stale compiled classes cause `Cannot instantiate class` errors.

### Run all tests (default)
```powershell
.\mvnw.cmd clean test -P all-brands
```

### Run only Arby's tests
```powershell
.\mvnw.cmd clean test -P arbys
```

### Run headless (CI-friendly)
```powershell
.\mvnw.cmd clean test -P arbys -Dheadless=true
```

### Run a specific TestNG group
```powershell
.\mvnw.cmd clean test -P arbys -Dgroups=smoke
.\mvnw.cmd clean test -P all-brands -Dgroups=regression
```

### Run with a different browser
```powershell
.\mvnw.cmd clean test -P arbys -Dbrowser=firefox
.\mvnw.cmd clean test -P arbys -Dbrowser=edge
```

### Override config at runtime
```powershell
.\mvnw.cmd clean test -Dactive.brand=arbys `
         -Dtestng.suite.file=testng-suites/testng-arbys.xml `
         -Dbrowser=chrome `
         -Dheadless=true
```

---

## Adding a New Brand

Adding a brand (e.g. Dunkin') requires **4 steps** with **zero changes** to existing classes:

1. **Enum** — `Brand.java` already contains `DUNKIN`. No change needed.

2. **Page class** — Create `src/main/java/com/inspire/pages/brands/DunkinPage.java`:
   ```java
   public class DunkinPage extends AbstractBrandPage {
       @Override protected String getBrandPagePath() { return "/dunkin"; }
       @Override public String getBrandDisplayName()  { return Brand.DUNKIN.getDisplayName(); }
       // Add Dunkin'-specific @FindBy locators and methods here
   }
   ```

3. **Factory** — In `BrandPageFactory.java`, uncomment (or add):
   ```java
   case DUNKIN:
       return new DunkinPage(driver);
   ```

4. **Test class** — Create `src/test/java/com/inspire/tests/brands/DunkinTest.java`:
   ```java
   public class DunkinTest extends AbstractBrandTest {
       @Override
       protected AbstractBrandPage getBrandPage() {
           return new DunkinPage(DriverManager.getDriver());
       }
       // Add Dunkin'-specific @Test methods here
   }
   ```

   And add it to `testng-all.xml`:
   ```xml
   <test name="Dunkin' Brand Page Tests">
       <classes>
           <class name="com.inspire.tests.brands.DunkinTest"/>
       </classes>
   </test>
   ```

All 2 common brand tests (TC-B-01, TC-B-03) run automatically for the new brand.

---

## Reports

After each run, reports are written to:

```
test-output/
├── extent-reports/
│   └── <timestamp>/
│       └── report.html        ← Open in any browser
├── screenshots/
│   └── <TestName>_<timestamp>.png  ← Captured on failure
└── logs/
    └── automation.log
```

The HTML report includes:
- Pass / Fail / Skip status per test
- Step-level log entries
- Inline failure screenshots
- System info (browser, OS, active brand, Java version)

---

## TestLink & Jenkins Orchestration

This project ships a ready-to-run **TestLink** instance (test management) and a
**Jenkins** CI pipeline — both Docker-based. Anyone who clones the repo can reproduce
the exact same environment and data state with a few commands.

### What you get out of the box

| Tool | URL | Credentials | What's pre-loaded |
|------|-----|-------------|-------------------|
| **TestLink 1.9.20** | http://localhost:8080 | `admin` / `admin` | Full IBF project — all test suites, test cases, test plans, builds, and execution history |
| **Jenkins LTS** | http://localhost:8090 | *(no login required)* | Two pre-registered pipelines: `Inspire-Arbys-Smoke` and `Inspire-Arbys-Full-Regression` |

---

### Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Docker Desktop** | Ensure it is running before any `docker compose` command |
| **JDK 21** | Required only if running tests locally (not needed for Jenkins-only setup) |
| **Chrome** | Required only for local test runs |
| **Git** | To clone the repo |

---

### Step 1 — Start TestLink

TestLink runs on **port 8080**.

```powershell
cd testlink
docker compose up -d --build   # first run: builds image + seeds DB (~2–3 min)
```

On first start, MariaDB auto-imports `testlink/initdb/seed.sql` which contains:
- The **"Inspire Brands Franchising" (IBF)** project
- All **test suites**: Home Page Tests, Brand Pages → Arby's, Common Brand Tests
- All **test cases**: TC-H-01..11, TC-B-01..12, TC-A-01..11 (with steps and expected results)
- All **test plans**: Home Page Tests, Arby's Brand Page Tests
- All **builds** and **execution results** (pass/fail history)

Open http://localhost:8080 → login `admin` / `admin` — everything is ready, no manual setup.

> **Seed only runs once** (when the DB volume is empty). If you have a leftover volume
> from a previous run and want a clean re-seed:
> ```powershell
> docker compose down -v   # destroys volumes → next start re-imports seed.sql
> docker compose up -d --build
> ```

#### TestLink day-to-day commands

```powershell
docker compose up -d      # start (data in volumes survives restarts)
docker compose down       # stop (volumes kept — data preserved)
docker compose down -v    # full teardown — volumes deleted, re-seeds on next start
```

---

### Step 2 — Start Jenkins

Jenkins runs on **port 8090** (no conflict with TestLink on 8080).

```powershell
cd jenkins
docker compose up -d --build   # first run: builds image with JDK 21 + Chrome + plugins (~3–5 min)
```

The custom image pre-installs all required plugins at build time
(`workflow-aggregator`, `git`, `junit`, `pipeline-stage-view`) — no update-center
prompts, no wizard.

```powershell
docker compose up -d      # subsequent starts (image cached — instant)
docker compose down       # stop
```

#### Step 2a — Register the pipeline jobs

The job XML configs are committed to `jenkins/`. Run the PowerShell script once
to create both pipelines in Jenkins:

```powershell
cd jenkins
.\create-jenkins-jobs.ps1
```

This registers:

| Job | Default parameters | Suite |
|-----|--------------------|-------|
| `Inspire-Arbys-Smoke` | `BRAND_PROFILE=arbys`, `TEST_GROUPS=smoke`, `HEADLESS=true` | Smoke only |
| `Inspire-Arbys-Full-Regression` | `BRAND_PROFILE=arbys`, `TEST_GROUPS=all`, `HEADLESS=true` | Full suite |

Both jobs read the `Jenkinsfile` from the **local mounted workspace**
(`file:///workspace/InspireFranchises`) — no GitHub token needed.

Open http://localhost:8090 → both pipelines appear ready to run.

---

### Step 3 — Trigger a build

Click **Build with Parameters** in the Jenkins UI, or use PowerShell:

```powershell
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$crumb   = Invoke-RestMethod -Uri "http://localhost:8090/crumbIssuer/api/json" -WebSession $session
Invoke-RestMethod `
  -Uri "http://localhost:8090/job/Inspire-Arbys-Full-Regression/buildWithParameters?BRAND_PROFILE=arbys&TEST_GROUPS=smoke&HEADLESS=true" `
  -Method Post `
  -Headers @{$crumb.crumbRequestField = $crumb.crumb} `
  -WebSession $session
```

After the build completes, artifacts are available at:

```
http://localhost:8090/job/Inspire-Arbys-Full-Regression/<build-number>/artifact/
```

The `test-output/` folder there contains the **Extent HTML report** (with inline
screenshots) and logs. Download everything as a single ZIP via the
`(all files in zip)` link.

---

### How the local workspace mount works

The Jenkins container mounts the project root read-only:

```
Host path (Windows):    C:\code\...\InspireFranchises\
Container path:         /workspace/InspireFranchises   (read-only)
Repository URL in jobs: file:///workspace/InspireFranchises
```

Jenkins clones from the local filesystem on every build — no GitHub push required.
Only **committed** changes are visible (standard `git clone` behaviour).

> **Note:** Two JVM flags enable this pattern and are already set in
> `jenkins/docker-compose.yml`:
> - `-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true` — permits `file://` URLs
> - `safe.directory=*` baked into the Dockerfile — resolves Git's ownership check
>   when a Windows-mounted directory is accessed from a Linux container (Git 2.35+)

---

### Docker files reference

| File | Purpose |
|------|---------|
| `testlink/Dockerfile` | PHP 7.4 + Apache + all required PHP extensions + TestLink 1.9.20 source |
| `testlink/docker-compose.yml` | `testlink_app` (port 8080) + `testlink_db` (MariaDB 10.11); named volumes; DB healthcheck |
| `testlink/initdb/seed.sql` | Full MariaDB dump — project, suites, TCs, plans, builds, executions |
| `jenkins/Dockerfile` | Jenkins LTS + JDK 21 + Chrome stable + plugins baked in; `safe.directory=*` set |
| `jenkins/docker-compose.yml` | Jenkins on port 8090; project root mounted at `/workspace/InspireFranchises`; `ALLOW_LOCAL_CHECKOUT` flag |
| `jenkins/job-smoke.xml` | Jenkins job config for `Inspire-Arbys-Smoke` pipeline |
| `jenkins/job-full-regression.xml` | Jenkins job config for `Inspire-Arbys-Full-Regression` pipeline |
| `jenkins/create-jenkins-jobs.ps1` | PowerShell script — registers both jobs via Jenkins REST API |
| `Jenkinsfile` | Declarative pipeline: Checkout → Compile → Test → Archive artifacts + JUnit results |

---

### Keeping the seed up to date

After you add new test cases, plans, or execution results in TestLink, refresh
`seed.sql` so future cloners get the latest state:

```powershell
docker exec testlink_db mysqldump -u root -proot_secret `
  --single-transaction --routines --triggers --databases testlink `
  | Out-File -FilePath testlink/initdb/seed.sql -Encoding UTF8

git add testlink/initdb/seed.sql
git commit -m "chore(testlink): refresh seed with latest TCs and execution results"
git push origin master
```

---

## Configuration Reference

### `config.properties`

| Key | Default | Description |
|---|---|---|
| `browser` | `chrome` | Browser: `chrome`, `firefox`, `edge` |
| `headless` | `false` | Run headless |
| `base.url` | `https://www.franchising.inspirebrands.com` | Base URL |
| `active.brand` | `all` | Which brand properties file to load |
| `explicit.wait.sec` | `15` | Explicit wait timeout (seconds) |
| `page.load.timeout.sec` | `30` | Page load timeout (seconds) |

### `brands/<brand>.properties`

| Key | Example | Description |
|---|---|---|
| `brand.page.url` | `/arbys` | Brand page path |
| `brand.display.name` | `Arby's` | Human-readable brand name |
| `brand.hero.heading` | `Franchise with Arby's` | Expected hero heading |
| `brand.liquid.assets` | `500,000` | Liquid assets requirement |
| `brand.net.worth` | `1,000,000` | Net worth requirement |
| `brand.formats` | `Free Standing,Endcap,Small Format` | Comma-separated formats |
