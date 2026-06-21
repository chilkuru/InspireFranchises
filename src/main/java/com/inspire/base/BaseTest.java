package com.inspire.base;

import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.MediaEntityBuilder;
import com.aventstack.extentreports.Status;
import com.inspire.driver.DriverManager;
import com.inspire.utils.ExtentReportManager;
import com.inspire.utils.ScreenshotUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.ITestResult;
import org.testng.annotations.*;

/**
 * Abstract base class for all TestNG test classes.
 *
 * <p>Responsibilities:
 * <ul>
 *   <li>{@code @BeforeSuite}  – initialises Extent Reports
 *   <li>{@code @BeforeMethod} – spins up a WebDriver instance; creates the
 *                               Extent test node for the running test
 *   <li>{@code @AfterMethod}  – logs PASS / FAIL to Extent; takes a screenshot
 *                               on failure; quits the WebDriver
 *   <li>{@code @AfterSuite}   – flushes the Extent report to disk
 * </ul>
 *
 * <p>Test classes extend this class and gain all lifecycle management for free,
 * keeping them focused solely on assertion logic (Single Responsibility).
 */
public abstract class BaseTest {

    protected final Logger log = LogManager.getLogger(getClass());

    // ── Suite lifecycle ────────────────────────────────────────────────────────

    @BeforeSuite(alwaysRun = true)
    public void setUpSuite() {
        log.info("=== Test Suite Starting ===");
        ExtentReportManager.getInstance().initReports();
    }

    @AfterSuite(alwaysRun = true)
    public void tearDownSuite() {
        log.info("=== Test Suite Finished – flushing reports ===");
        ExtentReportManager.getInstance().flushReports();
    }

    // ── Method lifecycle ───────────────────────────────────────────────────────

    /**
     * Runs before every test method.
     *
     * <p>The {@code ITestResult} parameter lets us read the test method name
     * to create a meaningful Extent node before the test body executes.
     *
     * @param result injected by TestNG
     */
    @BeforeMethod(alwaysRun = true)
    public void setUpMethod(ITestResult result) {
        String testName   = result.getMethod().getMethodName();
        String testDesc   = result.getMethod().getDescription();
        String reportName = testName + (testDesc != null && !testDesc.isBlank()
                            ? " – " + testDesc : "");

        log.info("──── Starting test: {} ────", testName);
        ExtentReportManager.getInstance().createTest(reportName, testDesc);

        DriverManager.initDriver();
    }

    /**
     * Runs after every test method.
     *
     * <p>Logs PASS / FAIL / SKIP to Extent, captures a screenshot on failure,
     * then quits the WebDriver regardless of outcome.
     *
     * @param result injected by TestNG
     */
    @AfterMethod(alwaysRun = true)
    public void tearDownMethod(ITestResult result) {
        ExtentTest test = ExtentReportManager.getInstance().getTest();

        if (test != null) {
            switch (result.getStatus()) {
                case ITestResult.SUCCESS:
                    test.log(Status.PASS, "Test PASSED");
                    log.info("Test PASSED: {}", result.getMethod().getMethodName());
                    break;

                case ITestResult.FAILURE:
                    String failMsg = result.getThrowable() != null
                            ? result.getThrowable().getMessage()
                            : "Unknown failure";
                    test.log(Status.FAIL, "Test FAILED: " + failMsg);
                    attachScreenshot(Status.FAIL, "Screenshot at failure");
                    log.error("Test FAILED: {} – {}",
                            result.getMethod().getMethodName(), failMsg);
                    break;

                case ITestResult.SKIP:
                    test.log(Status.SKIP, "Test SKIPPED: " +
                            (result.getThrowable() != null
                            ? result.getThrowable().getMessage()
                            : ""));
                    log.warn("Test SKIPPED: {}", result.getMethod().getMethodName());
                    break;

                default:
                    break;
            }
        }

        ExtentReportManager.getInstance().removeTest();
        DriverManager.quitDriver();
        log.info("──── Finished test: {} ────", result.getMethod().getMethodName());
    }

    // ── Protected helpers ──────────────────────────────────────────────────────

    /**
     * Logs an informational step to the Extent test node and attaches
     * a screenshot of the current browser state.
     *
     * @param message step description
     */
    protected void logStep(String message) {
        log.info(message);
        attachScreenshot(Status.INFO, message);
    }

    /**
     * Logs a PASS assertion step to the Extent test node and attaches
     * a screenshot confirming the visual state after the assertion.
     *
     * @param message assertion description
     */
    protected void logPass(String message) {
        log.info("PASS: {}", message);
        attachScreenshot(Status.PASS, message);
    }

    /**
     * Logs a FAIL step to the Extent test node without stopping the test.
     * A screenshot is attached to show the failing state.
     *
     * @param message failure description
     */
    protected void logFail(String message) {
        log.error("FAIL: {}", message);
        attachScreenshot(Status.FAIL, message);
    }

    // ── Private helpers ────────────────────────────────────────────────────────

    /**
     * Captures the current browser state, saves the PNG file into
     * {@code <reportDir>/screenshots/}, then attaches it to the current
     * Extent test node using a relative path ({@code screenshots/<file>.png}).
     *
     * <p>A relative path means the image resolves correctly when the report
     * HTML is opened in any browser — no absolute paths, no broken images.
     *
     * @param status  Extent log level (INFO / PASS / FAIL)
     * @param message label shown next to the screenshot
     */
    private void attachScreenshot(Status status, String message) {
        ExtentTest test = ExtentReportManager.getInstance().getTest();
        if (test == null) return;
        try {
            String reportDir = ExtentReportManager.getInstance().getReportDir();
            if (reportDir == null) {
                test.log(status, message);
                return;
            }
            // Save screenshot into a screenshots/ sub-folder next to report.html
            String screenshotDir = reportDir + "screenshots";
            String filename = ScreenshotUtils.captureToDirectory(
                    DriverManager.getDriver(), message, screenshotDir);

            if (filename != null) {
                // Relative path from report.html → screenshots/<file>.png
                String relativePath = "screenshots" + java.io.File.separator + filename;
                test.log(status, message,
                        MediaEntityBuilder
                                .createScreenCaptureFromPath(relativePath)
                                .build());
            } else {
                test.log(status, message);
            }
        } catch (Exception e) {
            log.warn("Could not attach screenshot to report: {}", e.getMessage());
            ExtentReportManager.getInstance().getTest().log(status, message);
        }
    }
}
