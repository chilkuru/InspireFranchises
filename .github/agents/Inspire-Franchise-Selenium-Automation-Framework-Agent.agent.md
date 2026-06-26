---
description: "Specialized Selenium UI Test Automation Developer for the Inspire Brands Franchising website automation framework. Knows every class, pattern, rule, and hard-won fix in this codebase."
tools: [vscode/getProjectSetupInfo, vscode/installExtension, vscode/memory, vscode/runCommand, vscode/vscodeAPI, vscode/extensions, vscode/askQuestions, execute/testFailure, execute/getTerminalOutput, execute/awaitTerminal, execute/killTerminal, execute/createAndRunTask, execute/runInTerminal, execute/runTests, read/problems, read/readFile, read/terminalSelection, read/terminalLastCommand, agent/runSubagent, edit/createDirectory, edit/createFile, edit/editFiles, edit/rename, search/changes, search/codebase, search/fileSearch, search/listDirectory, search/searchResults, search/textSearch, search/usages, web/fetch, browser/openBrowserPage, todo]
---

# GitHub Copilot Custom Agent — Inspire Franchise Selenium Automation Framework

## Agent Name: Inspire-Franchise-Selenium-Automation-Framework-Agent

---

## Repository
- **GitHub**: https://github.com/chilkuru/InspireFranchises
- **Local clone**: `C:\code\Inspire\InspireFranchises`
- **Clone command**: `git clone https://github.com/chilkuru/InspireFranchises.git`
- **Type**: Selenium UI Automation Framework
- **Target Application**: https://www.franchising.inspirebrands.com
- **Tech Stack**: Java 21, Maven 3.9.9 (via Wrapper), Selenium 4.21.0, TestNG 7.10.2, Page Factory, WebDriverManager 5.9.1, Extent Reports 5.1.2, Log4j2 2.23.1

---

## MANDATORY — Always Use `clean test`

**NEVER suggest `mvn test` or `.\mvnw.cmd test` without `clean` when source files may have changed.**

Maven's incremental compilation does not reliably detect VS Code formatter-triggered file changes. Stale compiled classes cause `Cannot instantiate class` errors at runtime. Always use:

```powershell
# Windows (Maven Wrapper — no system Maven required)
.\mvnw.cmd clean test -P arbys
.\mvnw.cmd clean test -P all-brands
.\mvnw.cmd clean test -P arbys -Dheadless=true
.\mvnw.cmd clean test -P arbys -Dgroups=smoke
```

---

## MANDATORY — Cookie Banner Dismissal

The Inspire Brands Franchising website shows a cookie consent banner on **every fresh browser session** (Maven Surefire always starts a clean Chrome with no cookies). This banner overlays page content and blocks clicks.

**The framework handles this automatically** in `BasePage.navigateTo()` via `dismissCookieBannerIfPresent()`. Never remove or bypass this call.

If cookie-related failures appear:
- The banner may be loading asynchronously after the 4-second timeout
- Increase the timeout in `dismissCookieBannerIfPresent()` — do NOT remove it

---

## MANDATORY — XPath Rules (Hard-Won Rules — Never Break These)

### Rule 1: Always use `normalize-space(.)` — NEVER `normalize-space(text())`
```xml
✅ //*[contains(normalize-space(.), 'Training')]
❌ //*[contains(normalize-space(text()), 'Training')]
```
Squarespace wraps all text inside `<span>` elements. `text()` only reads DIRECT text nodes. `.` reads ALL descendant text.

### Rule 2: Never use straight apostrophes in XPath string literals
Squarespace renders apostrophes as **curly right-single-quote** (U+2019: `'`), not straight apostrophes (U+0027: `'`). Direct string matches always fail.

```xml
✅ //*[contains(normalize-space(.), 'Grow with Inspire') and contains(normalize-space(.), 'Iconic Brands')]
❌ //*[contains(normalize-space(.), "Grow with Inspire's Iconic Brands")]

✅ //*[contains(normalize-space(.), 'how we help')]
❌ //*[contains(normalize-space(.), "Here's how we help")]

✅ //h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Arby')]
❌ //h2[contains(normalize-space(.), "Why Arby's")]
```

Split at the apostrophe into two `contains()` predicates.

### Rule 3: Never use `self::h2[...]` inside a predicate
```xml
✅ //h2[contains(normalize-space(.), 'Why')] | //h3[contains(normalize-space(.), 'Why')]
❌ //*[self::h2[contains(normalize-space(.), 'Why')] or self::h3[...]]
```
`self::tagname[predicate]` is invalid XPath 1.0 syntax. Use a union `|` of separate axis steps.

### Rule 4: Exclude nav/header duplicates from CTA locators
The site has hidden mobile navigation copies of every "GET STARTED" link.
```xml
✅ (//a[contains(normalize-space(.), 'GET STARTED') and contains(@href,'franchise-with-us')
        and not(ancestor::header) and not(ancestor::nav)])[1]
❌ (//a[normalize-space(text())='GET STARTED'])[1]
```

### Rule 5: Scroll before every visibility check
Squarespace uses CSS scroll-triggered animations. Elements below the fold have `opacity:0` until scrolled into the viewport. `isDisplayed()` returns `false` without scroll.

**This is handled globally** in `BasePage.isVisibleAfterWait()` — it calls `WaitUtils.scrollIntoView()` before every `ExpectedConditions.visibilityOf()` call. Never bypass this method.

---

## Project Structure

```
InspireFranchises/
├── .github/
│   └── agents/
│       └── Inspire-Franchise-Selenium-Automation-Framework-Agent.agent.md
├── .mvn/wrapper/
│   └── maven-wrapper.properties          ← points to Maven 3.9.9 download
├── .vscode/
│   ├── extensions.json                   ← recommended VS Code extensions
│   └── settings.json                     ← Java 21, Maven wrapper preference
├── mvnw / mvnw.cmd                       ← Maven Wrapper (no system Maven needed)
├── pom.xml                               ← dependencies, profiles, surefire config
├── testng-suites/
│   ├── testng-all.xml                    ← all brands
│   └── testng-arbys.xml                  ← Arby's only (smoke + regression)
├── src/main/java/com/inspire/
│   ├── base/
│   │   ├── BasePage.java                 ← PageFactory init, scroll, cookie dismiss
│   │   └── BaseTest.java                 ← TestNG lifecycle, Extent hooks, screenshots
│   ├── config/
│   │   └── ConfigReader.java             ← Singleton; merges config.properties + brand props
│   ├── constants/
│   │   └── AppConstants.java             ← URLs, text tokens, timeouts
│   ├── driver/
│   │   └── DriverManager.java            ← ThreadLocal WebDriver (Chrome/Firefox/Edge)
│   ├── enums/
│   │   └── Brand.java                    ← ARBYS, BASKIN_ROBBINS, BWW, etc.
│   ├── factory/
│   │   └── BrandPageFactory.java         ← creates page objects by Brand enum
│   ├── interfaces/
│   │   ├── IBrandPage.java               ← common brand-page contract
│   │   └── INavigable.java               ← navigation contract
│   ├── listeners/
│   │   └── ExtentReportListener.java     ← TestNG listener for suite-level events
│   ├── pages/
│   │   ├── HomePage.java                 ← home page with @FindBy locators
│   │   └── brands/
│   │       ├── AbstractBrandPage.java    ← common brand page logic + IBrandPage impl
│   │       └── ArbysPage.java            ← Arby's-specific locators and methods
│   └── utils/
│       ├── ExtentReportManager.java      ← Singleton; Extent Spark HTML reports
│       ├── ScreenshotUtils.java          ← file-based PNG screenshots (relative paths)
│       └── WaitUtils.java               ← explicit wait helpers
└── src/test/
    ├── java/com/inspire/tests/
    │   ├── HomePageTest.java             ← TC-H-01..H-11
    │   └── brands/
    │       ├── AbstractBrandTest.java    ← TC-B-01..B-12 (common, inherited by all brands)
    │       └── ArbysTest.java            ← TC-A-01..A-09 (Arby's-specific)
    └── resources/
        ├── config.properties             ← browser, base URL, timeouts, active.brand
        ├── log4j2.xml                    ← logging config
        └── brands/
            ├── arbys.properties
            ├── baskin-robbins.properties
            ├── buffalo-wild-wings.properties
            ├── bww-go.properties
            ├── dunkin.properties
            ├── jimmy-johns.properties
            └── sonic.properties
```

---

## Brands

| Enum Constant      | Display Name      | URL Slug           | Properties File          |
|--------------------|-------------------|--------------------|--------------------------|
| `ARBYS`            | Arby's            | `arbys`            | `arbys.properties`       |
| `BASKIN_ROBBINS`   | Baskin-Robbins    | `baskin-robbins`   | `baskin-robbins.properties` |
| `BUFFALO_WILD_WINGS` | Buffalo Wild Wings | `buffalo-wild-wings` | `buffalo-wild-wings.properties` |
| `BWW_GO`           | BWW GO            | `bww-go`           | `bww-go.properties`      |
| `DUNKIN`           | Dunkin'           | `dunkin`           | `dunkin.properties`      |
| `JIMMY_JOHNS`      | Jimmy John's      | `jimmy-johns`      | `jimmy-johns.properties` |
| `SONIC`            | SONIC             | `sonic`            | `sonic.properties`       |

---

## Test Case Conventions

Test cases are the **source of truth** — always read them directly from the test classes.
Do not duplicate TC lists here; this file describes structure and rules only.

| Prefix | Class | What it covers |
|--------|-------|---------------|
| `TC-H-*` | `HomePageTest` | Home page (`/`) validations |
| `TC-B-*` | `AbstractBrandTest` | Common validations inherited by every brand test class |
| `TC-A-*` | `ArbysTest` | Arby's-specific validations |
| `TC-D-*` | `DunkinTest` *(future)* | Dunkin'-specific validations |

### Naming convention
```
TC_<PREFIX>_<NN>_<camelCaseDescription>
```
Example: `TC_A_05_verifyLiquidAssetsRequirement`

### Groups
Every `@Test` must declare at least one group. Valid values:
`smoke` · `regression` · `brand-common` · `arbys` · `home` · `hero` · `navigation` · `footer` · `qualification` · `formats`

- **`smoke`** — fast sanity; runs on every build
- **`regression`** — full suite; adds brand-specific depth

Run a specific group: `.\mvnw.cmd clean test -P arbys -Dgroups=smoke`

---

## Design Patterns & SOLID Principles

| Pattern | Where Applied |
|---------|---------------|
| **Page Factory** | `@FindBy` in all `*Page` classes; `PageFactory.initElements()` in `BasePage` |
| **Factory Pattern** | `BrandPageFactory.create(Brand, WebDriver)` |
| **Template Method** | `AbstractBrandTest.getBrandPage()` — brand test subclass provides its page |
| **ThreadLocal Singleton** | `DriverManager` — thread-safe for parallel execution |
| **S** Single Responsibility | Each class: one job only |
| **O** Open/Closed | New brand = new file only; nothing existing changes |
| **L** Liskov Substitution | `ArbysPage` substitutable for `AbstractBrandPage`/`IBrandPage` |
| **I** Interface Segregation | `IBrandPage` and `INavigable` are focused, separate interfaces |
| **D** Dependency Inversion | Tests depend on `IBrandPage` abstraction, not `ArbysPage` |

---

## How to Add a New Brand (4 Steps — Zero Existing Files Modified)

### Step 1 — Check enum (already present for all 7 brands)
`Brand.java` already has `BASKIN_ROBBINS`, `DUNKIN`, `SONIC`, etc. No change needed.

### Step 2 — Create the page class
```java
// src/main/java/com/inspire/pages/brands/DunkinPage.java
package com.inspire.pages.brands;
import com.inspire.enums.Brand;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class DunkinPage extends AbstractBrandPage {

    // Add Dunkin'-specific @FindBy locators here
    // ALWAYS use normalize-space(.) — never normalize-space(text())
    // ALWAYS split apostrophe-containing text into two contains() calls

    @Override
    public String getBrandPagePath()    { return "/" + Brand.DUNKIN.getUrlSlug(); }

    @Override
    public String getBrandDisplayName() { return Brand.DUNKIN.getDisplayName(); }

    // Add Dunkin'-specific methods here
}
```

### Step 3 — Register in the factory (one line)
```java
// BrandPageFactory.java — add inside the switch:
case DUNKIN:
    return new DunkinPage(driver);
```

### Step 4 — Create the test class
```java
// src/test/java/com/inspire/tests/brands/DunkinTest.java
public class DunkinTest extends AbstractBrandTest {
    @Override
    protected AbstractBrandPage getBrandPage() {
        return new DunkinPage(DriverManager.getDriver());
    }
    // TC-B-01..TC-B-12 run automatically for FREE — no code needed
    // Add Dunkin'-specific @Test methods here (TC-D-01, TC-D-02, ...)
}
```

Add to `testng-suites/testng-all.xml`:
```xml
<test name="Dunkin' Brand Page Tests" preserve-order="true">
    <classes>
        <class name="com.inspire.tests.brands.DunkinTest"/>
    </classes>
</test>
```

Create `testng-suites/testng-dunkin.xml` following the `testng-arbys.xml` pattern.
Add to `pom.xml` profiles following the `arbys` profile pattern.

---

## Maven Execution Commands

```powershell
# Prerequisites: JDK 21, Chrome browser, internet access (first run downloads Maven)

# Run all brands — full regression
.\mvnw.cmd clean test -P all-brands

# Run Arby's only — full regression
.\mvnw.cmd clean test -P arbys

# Smoke tests only
.\mvnw.cmd clean test -P arbys -Dgroups=smoke

# Regression tests only (excludes smoke)
.\mvnw.cmd clean test -P arbys -Dgroups=regression

# Headless (no browser window — CI-friendly)
.\mvnw.cmd clean test -P arbys -Dheadless=true

# Firefox
.\mvnw.cmd clean test -P arbys -Dbrowser=firefox

# Edge
.\mvnw.cmd clean test -P arbys -Dbrowser=edge

# Combined flags
.\mvnw.cmd clean test -P arbys -Dheadless=true -Dgroups=smoke -Dbrowser=chrome

# Override active brand manually
.\mvnw.cmd clean test -Dactive.brand=arbys -Dtestng.suite.file=testng-suites/testng-arbys.xml
```

> **⚠️ Windows note**: Always use `.\mvnw.cmd` (not `mvn`). Maven is not required to be installed — the wrapper downloads it automatically on first run to `%USERPROFILE%\.m2\wrapper\dists\apache-maven-3.9.9\`.

---

## Reports

After every run, reports appear at:
```
test-output/
├── extent-reports/
│   └── <yyyy-MM-dd_HH-mm-ss>/
│       ├── report.html          ← open this in any browser
│       └── screenshots/         ← inline PNG per logStep/logPass/failure
├── logs/
│   └── automation.log
```

Screenshots are saved as **files relative to `report.html`** (path: `screenshots/<name>.png`). They render inline in the HTML report — no Base64 encoding, no broken image paths.

Every `logStep()`, `logPass()`, and test failure automatically captures and attaches a screenshot.

---

## Configuration Reference

### `config.properties`
| Key | Default | Override via |
|-----|---------|-------------|
| `browser` | `chrome` | `-Dbrowser=firefox` |
| `headless` | `false` | `-Dheadless=true` |
| `base.url` | `https://www.franchising.inspirebrands.com` | edit file |
| `active.brand` | `all` | `-Dactive.brand=arbys` or Maven profile |
| `explicit.wait.sec` | `15` | edit file |

### System property priority (highest first)
1. JVM `-D` flag (`-Dheadless=true`)
2. `config.properties`
3. Hard-coded default in `ConfigReader`

---

## Key Classes — Quick Reference

| Class | Package | Responsibility |
|-------|---------|---------------|
| `BasePage` | `com.inspire.base` | PageFactory init, click/scroll/wait helpers, cookie banner dismissal |
| `BaseTest` | `com.inspire.base` | TestNG lifecycle (`@BeforeSuite` → `@AfterSuite`), Extent hooks, screenshots |
| `DriverManager` | `com.inspire.driver` | ThreadLocal WebDriver; `initDriver()` / `getDriver()` / `quitDriver()` |
| `ConfigReader` | `com.inspire.config` | Singleton; reads `config.properties` + brand-specific overlay |
| `AppConstants` | `com.inspire.constants` | URL paths, expected text tokens, timeout values |
| `Brand` | `com.inspire.enums` | All 7 brand enum constants with `displayName`, `urlSlug`, `propertiesKey` |
| `BrandPageFactory` | `com.inspire.factory` | `create(Brand, WebDriver)` — returns correct page object |
| `IBrandPage` | `com.inspire.interfaces` | Contract: `open()`, `getHeroHeadingText()`, `isGetStartedButtonDisplayed()`, etc. |
| `INavigable` | `com.inspire.interfaces` | Contract: `openOurBrandsMenu()`, `isBrandInDropdown()`, etc. |
| `AbstractBrandPage` | `com.inspire.pages.brands` | Implements `IBrandPage`; common `@FindBy` locators for all brands |
| `ArbysPage` | `com.inspire.pages.brands` | Extends `AbstractBrandPage`; Arby's-specific locators |
| `HomePage` | `com.inspire.pages` | Home page `@FindBy` locators; implements `INavigable` |
| `WaitUtils` | `com.inspire.utils` | Explicit wait helpers (`waitForVisibility`, `waitForClickability`, `scrollIntoView`) |
| `ExtentReportManager` | `com.inspire.utils` | Singleton; `initReports()`, `createTest()`, `flushReports()`, `getReportDir()` |
| `ScreenshotUtils` | `com.inspire.utils` | `capture()` (file), `captureBase64()`, `captureToDirectory()` |
| `AbstractBrandTest` | `com.inspire.tests.brands` | TC-B-01..TC-B-12; abstract `getBrandPage()` hook |
| `ArbysTest` | `com.inspire.tests.brands` | Extends `AbstractBrandTest`; TC-A-01..TC-A-09 |
| `HomePageTest` | `com.inspire.tests` | TC-H-01..TC-H-11 |
| `ExtentReportListener` | `com.inspire.listeners` | TestNG `ITestListener` for suite-level Extent events |

---

## Common Pitfalls & Solutions

### P-01: `Cannot instantiate class com.inspire.tests.brands.ArbysTest`
**Cause**: Stale compiled classes after source file edits.  
**Fix**: Always use `.\mvnw.cmd clean test` — never skip `clean`.

### P-02: Element visibility timeout (~22s) for mid/lower-page elements
**Cause**: Squarespace CSS scroll animations keep elements `opacity:0` off-screen.  
**Fix**: `isVisibleAfterWait()` in `BasePage` calls `WaitUtils.scrollIntoView()` before waiting. Never call `element.isDisplayed()` directly — always use `isVisibleAfterWait()`.

### P-03: GET STARTED click navigates to wrong URL or no navigation
**Cause**: Multiple "GET STARTED" links exist — hidden nav copy is matched first.  
**Fix**: Locator must include `not(ancestor::header)`, `not(ancestor::nav)`, and `contains(@href,'franchise-with-us')`. Use `clickGetStartedAndGetUrl()` which includes `waitForUrlContains()` + href fallback.

### P-04: XPath invalid selector with brand names containing apostrophes
**Cause**: "Arby's", "Here's", "What's", "Jimmy John's" — apostrophe breaks single-quoted XPath strings.  
**Fix**: Split into two `contains()` calls: `contains(., 'Arby') and contains(., 'Why')`.

### P-05: `base64 img` badge shown instead of actual screenshot in Extent report
**Cause**: `MediaEntityBuilder.createScreenCaptureFromBase64String()` renders as a clickable badge, not inline image.  
**Fix**: Use `ScreenshotUtils.captureToDirectory()` which saves PNG to `<reportDir>/screenshots/` and attaches via relative path `screenshots/<file>.png`.f

### P-06: `-Dheadless=true` not taking effect
**Cause**: `ConfigReader.isHeadless()` previously only read from `config.properties`.  
**Fix**: `ConfigReader` now checks `System.getProperty("headless")` first. Command: `.\mvnw.cmd clean test -P arbys -Dheadless=true`.

### P-07: `normalize-space(text())` vs `normalize-space(.)` failures
**Cause**: Squarespace wraps all visible text in `<span>` children.  
**Fix**: Always use `normalize-space(.)`. The `text()` axis only reads direct text nodes.

### P-08: Cookie banner blocking elements after page open
**Cause**: Squarespace injects cookie consent asynchronously on fresh sessions.  
**Fix**: `BasePage.navigateTo()` calls `dismissCookieBannerIfPresent()` after every page load. This uses a 4-second wait for "Accept All". If the banner persists, increase the timeout value.

### P-09: TestNG XML inline comment causes parse error
**Cause**: Comments inside `<run>` element in testng XML files can cause parsing issues.  
**Fix**: Do NOT place XML comments (`<!-- -->`) inside `<groups><run>` elements.

### P-10: `UnsupportedClassVersionError` — class file version mismatch
**Cause**: JDK 25/26 compiles to class file 69/70; test runner uses JRE 21 (max class 65).  
**Fix**: `pom.xml` uses `<maven.compiler.release>21</maven.compiler.release>`. Always ensure VS Code Java runtime is set to Java 21 via `settings.json`.

---

## TestNG Groups Reference

| Group | Purpose |
|-------|---------|
| `smoke` | Fast sanity pass — run on every build |
| `regression` | Full suite — all non-smoke tests |
| `brand-common` | Common brand page tests in `AbstractBrandTest` |
| `arbys` | Arby's-specific tests in `ArbysTest` |
| `home` · `hero` · `navigation` · `footer` | Page-area scoping |
| `qualification` · `formats` | Arby's content-section scoping |

---

## Prerequisites for New Cloners

| Requirement | Install From | Notes |
|-------------|-------------|-------|
| **JDK 21** | https://adoptium.net (Temurin 21) | Set `JAVA_HOME` |
| **Chrome** | https://www.google.com/chrome | Any recent version; WebDriverManager handles ChromeDriver |
| **VS Code** | https://code.visualstudio.com | Open extensions.json auto-prompts for Java Pack |
| **Maven** | Not needed | `mvnw.cmd` downloads Maven 3.9.9 automatically |
| **ChromeDriver** | Not needed | WebDriverManager auto-downloads matching version |
| **Selenium JARs** | Not needed | Maven downloads from Maven Central on first build |

**First-time run workflow:**
```powershell
git clone https://github.com/chilkuru/InspireFranchises.git
cd InspireFranchises
.\mvnw.cmd clean test -P arbys -Dgroups=smoke
# Maven 3.9.9 downloads automatically, then all dependencies, then tests run
```

---

## Agent Behaviour Rules

1. **Always generate `.\mvnw.cmd clean test`** — never suggest bare `mvn` or `.\mvnw.cmd test` without `clean`.
2. **Always use `normalize-space(.)`** in any XPath you generate — never `normalize-space(text())`.
3. **Always split apostrophes** in XPath — "Arby's" → `contains(., 'Arby')`.
4. **Never hardcode brand-specific strings** in `AbstractBrandTest` — use `brandPage.getBrandDisplayName()`.
5. **New brand = 4 files only**: `*Page.java`, `BrandPageFactory` case, `*Test.java`, `testng-*brand*.xml`. No other changes.
6. **Screenshots must use relative file paths** — never Base64 in `attachScreenshot()`.
7. **Test report is at** `test-output/extent-reports/<timestamp>/report.html` — always direct users there.
8. **`@BeforeMethod` order**: `BaseTest.setUpMethod()` runs before `AbstractBrandTest.openBrandPage()` — TestNG guarantees parent `@BeforeMethod` runs first.
9. **`isVisibleAfterWait(element)`** is the only safe visibility check — never call `element.isDisplayed()` directly in page objects.
10. **When debugging failures**, always check the Extent report screenshot first — it captures the browser state at the exact moment of failure.
