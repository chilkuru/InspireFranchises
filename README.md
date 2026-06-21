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
9. [Configuration Reference](#configuration-reference)

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

### Common Brand Page (TC-B-01 … TC-B-12) — inherited by every brand test class

| TC ID | Description | Group |
|---|---|---|
| TC-B-01 | Brand page loads at correct URL | smoke |
| TC-B-02 | Hero heading contains "Franchise with [Brand]" | smoke |
| TC-B-03 | Hero "GET STARTED" button displayed | smoke |
| TC-B-04 | "GET STARTED" navigates to `/franchise-with-us` | smoke |
| TC-B-05 | "Why [Brand]?" section displayed | regression |
| TC-B-06 | "Here's how we help" section displayed | regression |
| TC-B-07 | All three support pillars displayed (Training, Marketing, Technology) | regression |
| TC-B-08 | Qualification requirements section displayed | regression |
| TC-B-09 | "What's next?" section displayed | regression |
| TC-B-10 | All 5 franchise steps (Apply → Sign) displayed | regression |
| TC-B-11 | Footer displayed | regression |
| TC-B-12 | Cross-brand promotion links displayed | regression |

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

**Total: 34 test cases** (11 home + 12 common brand + 11 Arby's-specific)

---

## Prerequisites

| Requirement | Minimum Version |
|---|---|
| Java JDK | 11 |
| Maven | 3.8 |
| Chrome | Latest stable |
| Internet access | Required (tests hit the live site) |

WebDriverManager auto-downloads the matching ChromeDriver — no manual driver setup needed.

---

## Running Tests

### Run all tests (default)
```bash
mvn test
# or explicitly:
mvn test -P all-brands
```

### Run only Arby's tests
```bash
mvn test -P arbys
```

### Run headless (CI-friendly)
```bash
mvn test -P arbys -Dheadless=true
```

### Run a specific TestNG group
```bash
mvn test -P arbys -Dgroups=smoke
mvn test -P all-brands -Dgroups=regression
```

### Run with a different browser
```bash
mvn test -P arbys -Dbrowser=firefox
mvn test -P arbys -Dbrowser=edge
```

### Override config at runtime
```bash
mvn test -Dactive.brand=arbys \
         -Dtestng.suite.file=testng-suites/testng-arbys.xml \
         -Dbrowser=chrome \
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

All 12 common brand tests (TC-B-01 … TC-B-12) run automatically for the new brand.

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
