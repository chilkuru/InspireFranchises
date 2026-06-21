package com.inspire.driver;

import com.inspire.config.ConfigReader;
import com.inspire.constants.AppConstants;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;

import java.time.Duration;

/**
 * Thread-safe WebDriver manager using {@link ThreadLocal}.
 *
 * <p>A single {@link WebDriver} instance is maintained per thread, allowing
 * safe parallel test execution when TestNG is configured with multiple threads.
 *
 * <p>Single Responsibility: this class only manages the WebDriver lifecycle
 * (creation, retrieval, teardown). No page or test logic lives here.
 *
 * <p>Supported browsers (configure in config.properties):
 * <ul>
 *   <li>chrome   (default)
 *   <li>firefox
 *   <li>edge
 * </ul>
 */
public final class DriverManager {

    private static final Logger LOG = LogManager.getLogger(DriverManager.class);

    /** One WebDriver per thread – enables parallel suite execution. */
    private static final ThreadLocal<WebDriver> DRIVER_THREAD_LOCAL = new ThreadLocal<>();

    private DriverManager() {
        // utility class
    }

    // ── Public API ─────────────────────────────────────────────────────────────

    /**
     * Initialises and stores a new {@link WebDriver} for the current thread.
     * Must be called once per test (in {@code @BeforeMethod} / {@code @BeforeClass}).
     */
    public static void initDriver() {
        ConfigReader cfg = ConfigReader.getInstance();
        String browser   = cfg.getBrowser();
        boolean headless = cfg.isHeadless();

        LOG.info("Initialising WebDriver  browser={} headless={} thread={}",
                browser, headless, Thread.currentThread().getName());

        WebDriver driver = createDriver(browser, headless);
        configureDriver(driver, cfg);

        DRIVER_THREAD_LOCAL.set(driver);
        LOG.info("WebDriver ready: {}", driver.getClass().getSimpleName());
    }

    /**
     * Returns the {@link WebDriver} for the current thread.
     *
     * @throws IllegalStateException if {@link #initDriver()} has not been called
     */
    public static WebDriver getDriver() {
        WebDriver driver = DRIVER_THREAD_LOCAL.get();
        if (driver == null) {
            throw new IllegalStateException(
                    "WebDriver is null for thread " + Thread.currentThread().getName() +
                    ". Ensure DriverManager.initDriver() was called in @BeforeMethod.");
        }
        return driver;
    }

    /**
     * Quits the {@link WebDriver} and removes it from {@link ThreadLocal}.
     * Must be called in {@code @AfterMethod} / {@code @AfterClass} to prevent
     * memory leaks in parallel execution.
     */
    public static void quitDriver() {
        WebDriver driver = DRIVER_THREAD_LOCAL.get();
        if (driver != null) {
            LOG.info("Quitting WebDriver for thread {}", Thread.currentThread().getName());
            try {
                driver.quit();
            } catch (Exception e) {
                LOG.warn("Exception while quitting WebDriver: {}", e.getMessage());
            } finally {
                DRIVER_THREAD_LOCAL.remove();
            }
        }
    }

    // ── Private helpers ────────────────────────────────────────────────────────

    private static WebDriver createDriver(String browser, boolean headless) {
        switch (browser) {
            case "firefox": {
                WebDriverManager.firefoxdriver().setup();
                FirefoxOptions opts = new FirefoxOptions();
                if (headless) opts.addArguments("--headless");
                return new FirefoxDriver(opts);
            }
            case "edge": {
                WebDriverManager.edgedriver().setup();
                EdgeOptions opts = new EdgeOptions();
                if (headless) opts.addArguments("--headless");
                return new EdgeDriver(opts);
            }
            case "chrome":
            default: {
                WebDriverManager.chromedriver().setup();
                ChromeOptions opts = new ChromeOptions();
                if (headless) {
                    opts.addArguments("--headless=new");
                }
                opts.addArguments(
                        "--no-sandbox",
                        "--disable-dev-shm-usage",
                        "--disable-gpu",
                        "--window-size=1920,1080",
                        // Suppress "Chrome is being controlled by automated software" banner
                        "--disable-infobars",
                        "--disable-extensions"
                );
                // Disable automation flags that can cause site behaviour differences
                opts.setExperimentalOption("excludeSwitches",
                        new String[]{"enable-automation"});
                opts.setExperimentalOption("useAutomationExtension", false);
                return new ChromeDriver(opts);
            }
        }
    }

    private static void configureDriver(WebDriver driver, ConfigReader cfg) {
        driver.manage().window().maximize();
        driver.manage().timeouts()
                .pageLoadTimeout(Duration.ofSeconds(AppConstants.PAGE_LOAD_TIMEOUT_SEC))
                .implicitlyWait(Duration.ofSeconds(AppConstants.IMPLICIT_WAIT_SEC));
    }
}
