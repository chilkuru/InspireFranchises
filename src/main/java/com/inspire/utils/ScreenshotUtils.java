package com.inspire.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.*;
import org.openqa.selenium.io.FileHandler;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility for capturing browser screenshots.
 *
 * <p>Screenshots are saved to {@code test-output/screenshots/} with a
 * timestamp-and-test-name suffix so they can be easily correlated to
 * failing test cases.
 */
public final class ScreenshotUtils {

    private static final Logger LOG = LogManager.getLogger(ScreenshotUtils.class);
    private static final String SCREENSHOT_DIR = "test-output" + File.separator + "screenshots";

    private ScreenshotUtils() {}

    /**
     * Takes a screenshot and saves it to the screenshots directory.
     * Returns the absolute file path, or {@code null} on failure.
     */
    public static String capture(WebDriver driver, String testName) {
        try {
            File src  = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            String ts = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS").format(new Date());
            String safeName = testName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String destPath = SCREENSHOT_DIR + File.separator + safeName + "_" + ts + ".png";

            File dest = new File(destPath);
            dest.getParentFile().mkdirs();
            FileHandler.copy(src, dest);

            LOG.info("Screenshot saved: {}", destPath);
            return dest.getAbsolutePath();
        } catch (IOException | WebDriverException e) {
            LOG.error("Failed to capture screenshot for '{}': {}", testName, e.getMessage());
            return null;
        }
    }

    /**
     * Captures the current browser state as a Base64-encoded PNG string.
     * Use this when you want to embed the image directly inside an Extent
     * report (no file path dependency — works across machines and browsers).
     *
     * @param driver active WebDriver instance
     * @return Base64 string (no data-URI prefix), or {@code null} on failure
     */
    public static String captureBase64(WebDriver driver) {
        try {
            return ((TakesScreenshot) driver).getScreenshotAs(OutputType.BASE64);
        } catch (WebDriverException e) {
            LOG.error("Failed to capture Base64 screenshot: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Captures a screenshot and saves it to the specified directory.
     * Returns just the file name (not the full path) so that callers can
     * build a path relative to the Extent report HTML file.
     *
     * @param driver    active WebDriver instance
     * @param label     human-readable label used as the file name prefix
     * @param directory absolute path to the target directory
     * @return file name (e.g. {@code "My_Step_20260620_175530_123.png"}),
     *         or {@code null} on failure
     */
    public static String captureToDirectory(WebDriver driver, String label, String directory) {
        try {
            File src = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            String ts       = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS").format(new Date());
            String safeName = label.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            // Truncate label to 60 chars to avoid overly long filenames
            if (safeName.length() > 60) safeName = safeName.substring(0, 60);
            String filename = safeName + "_" + ts + ".png";

            File dest = new File(directory + File.separator + filename);
            dest.getParentFile().mkdirs();
            FileHandler.copy(src, dest);

            LOG.debug("Screenshot saved: {}", dest.getAbsolutePath());
            return filename;
        } catch (IOException | WebDriverException e) {
            LOG.error("Failed to capture screenshot to '{}': {}", directory, e.getMessage());
            return null;
        }
    }
}
