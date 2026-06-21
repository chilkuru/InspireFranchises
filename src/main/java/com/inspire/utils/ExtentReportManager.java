package com.inspire.utils;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Singleton manager for Extent Reports 5 (Spark reporter).
 *
 * <p>Reports are written to {@code test-output/extent-reports/<timestamp>/report.html}.
 * Each test creates its own {@link ExtentTest} node via {@link #createTest(String)}.
 *
 * <p>Usage pattern:
 * <pre>
 *   // In TestNG listener / BaseTest @BeforeSuite
 *   ExtentReportManager.getInstance().initReports();
 *
 *   // In @BeforeMethod
 *   ExtentTest test = ExtentReportManager.getInstance().createTest("TC01 - Verify hero");
 *
 *   // In test body
 *   ExtentReportManager.getInstance().getTest().pass("Hero heading visible");
 *
 *   // In @AfterSuite
 *   ExtentReportManager.getInstance().flushReports();
 * </pre>
 *
 * <p>Single Responsibility: this class only manages report lifecycle and
 * test node creation. No WebDriver or test-assertion logic lives here.
 */
public final class ExtentReportManager {

    private static final Logger LOG = LogManager.getLogger(ExtentReportManager.class);

    private static final ExtentReportManager INSTANCE = new ExtentReportManager();

    private ExtentReports extentReports;

    /** Absolute path to the folder that contains report.html (ends with separator). */
    private String reportDir;

    /** Thread-local storage ensures each thread writes to its own ExtentTest node. */
    private final ThreadLocal<ExtentTest> testThreadLocal = new ThreadLocal<>();

    private ExtentReportManager() {}

    // ── Public API ─────────────────────────────────────────────────────────────

    /** Returns the singleton instance. */
    public static ExtentReportManager getInstance() {
        return INSTANCE;
    }

    /**
     * Returns the absolute path to the folder containing {@code report.html}
     * (always ends with the platform file separator).
     * Used by screenshot utilities to save images next to the report so that
     * relative-path {@code <img src>} references resolve correctly in the browser.
     *
     * @return report directory path, or {@code null} if not yet initialised
     */
    public String getReportDir() {
        return reportDir;
    }

    /**
     * Initialises the Spark reporter and the {@link ExtentReports} instance.
     * Must be called once before any tests run (in {@code @BeforeSuite}).
     */
    public synchronized void initReports() {
        if (extentReports != null) {
            // already initialised (guard for parallel test setups)
            return;
        }

        String timestamp  = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss").format(new Date());
        reportDir  = "test-output" + File.separator + "extent-reports"
                            + File.separator + timestamp + File.separator;
        String reportPath = reportDir + "report.html";

        // Create directory if needed
        new File(reportDir).mkdirs();

        ExtentSparkReporter spark = new ExtentSparkReporter(reportPath);
        spark.config().setReportName("Inspire Brands Franchising – Automation Report");
        spark.config().setDocumentTitle("Inspire Automation");
        spark.config().setTheme(Theme.DARK);
        spark.config().setEncoding("UTF-8");
        spark.config().setTimeStampFormat("MMM dd, yyyy HH:mm:ss");

        extentReports = new ExtentReports();
        extentReports.attachReporter(spark);

        // System/environment info shown at the top of the report
        extentReports.setSystemInfo("Application", "Inspire Brands Franchising");
        extentReports.setSystemInfo("Environment", System.getProperty("env", "TEST"));
        extentReports.setSystemInfo("Browser",
                System.getProperty("browser", "chrome").toUpperCase());
        extentReports.setSystemInfo("Active Brand",
                System.getProperty("active.brand", "all").toUpperCase());
        extentReports.setSystemInfo("OS", System.getProperty("os.name"));
        extentReports.setSystemInfo("Java Version", System.getProperty("java.version"));

        LOG.info("Extent Reports initialised. Report path: {}", reportPath);
    }

    /**
     * Creates a new test node in the report for the current thread.
     *
     * @param testName human-readable test name
     * @return the created {@link ExtentTest}
     */
    public ExtentTest createTest(String testName) {
        ExtentTest test = extentReports.createTest(testName);
        testThreadLocal.set(test);
        return test;
    }

    /**
     * Creates a new test node with a description.
     *
     * @param testName    human-readable test name
     * @param description optional description shown in the report
     * @return the created {@link ExtentTest}
     */
    public ExtentTest createTest(String testName, String description) {
        ExtentTest test = extentReports.createTest(testName, description);
        testThreadLocal.set(test);
        return test;
    }

    /**
     * Returns the {@link ExtentTest} for the current thread.
     * Returns {@code null} if {@link #createTest} has not been called yet.
     */
    public ExtentTest getTest() {
        return testThreadLocal.get();
    }

    /**
     * Removes the current thread's test reference from {@link ThreadLocal}.
     * Call in {@code @AfterMethod} after logging the test result.
     */
    public void removeTest() {
        testThreadLocal.remove();
    }

    /**
     * Writes all pending test results to the HTML report file.
     * Must be called once after all tests complete (in {@code @AfterSuite}).
     */
    public synchronized void flushReports() {
        if (extentReports != null) {
            extentReports.flush();
            LOG.info("Extent Reports flushed successfully.");
        }
    }
}
