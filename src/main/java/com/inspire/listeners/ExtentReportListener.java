package com.inspire.listeners;

import com.aventstack.extentreports.Status;
import com.inspire.utils.ExtentReportManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

/**
 * TestNG listener that provides supplemental Extent Reports logging.
 *
 * <p>This listener is registered in every TestNG suite XML file via:
 * <pre>
 *   &lt;listeners&gt;
 *     &lt;listener class-name="com.inspire.listeners.ExtentReportListener"/&gt;
 *   &lt;/listeners&gt;
 * </pre>
 *
 * <p>Because {@code BaseTest} already handles per-method Extent logging in its
 * {@code @AfterMethod}, this listener is a thin supplement for suite-level
 * events and acts as a safety net for tests not extending {@code BaseTest}.
 */
public class ExtentReportListener implements ITestListener {

    private static final Logger LOG = LogManager.getLogger(ExtentReportListener.class);

    // ── ITestListener callbacks ────────────────────────────────────────────────

    @Override
    public void onStart(ITestContext context) {
        LOG.info("Test context starting: {}", context.getName());
    }

    @Override
    public void onFinish(ITestContext context) {
        LOG.info("Test context finished: {} – passed={} failed={} skipped={}",
                context.getName(),
                context.getPassedTests().size(),
                context.getFailedTests().size(),
                context.getSkippedTests().size());
    }

    @Override
    public void onTestStart(ITestResult result) {
        LOG.info("Test started: {}", result.getMethod().getMethodName());
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        logToExtent(result, Status.PASS, null);
    }

    @Override
    public void onTestFailure(ITestResult result) {
        String reason = result.getThrowable() != null
                ? result.getThrowable().getMessage() : "Unknown";
        logToExtent(result, Status.FAIL, reason);
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        String reason = result.getThrowable() != null
                ? result.getThrowable().getMessage() : "No reason provided";
        logToExtent(result, Status.SKIP, reason);
    }

    // ── Helpers ────────────────────────────────────────────────────────────────

    private void logToExtent(ITestResult result, Status status, String detail) {
        if (ExtentReportManager.getInstance().getTest() != null) {
            // BaseTest already handles this – avoid duplicate entries
            return;
        }
        // Fallback for tests not extending BaseTest
        String name = result.getMethod().getMethodName();
        ExtentReportManager.getInstance().createTest(name)
                .log(status, status + ": " + name + (detail != null ? " – " + detail : ""));
    }
}
