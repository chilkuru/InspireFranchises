package com.inspire.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Reusable explicit-wait helpers.
 *
 * <p>All methods accept a configurable timeout so callers can use a shorter
 * timeout for negative-case assertions without slowing down the suite.
 *
 * <p>Single Responsibility: this class owns only wait/synchronisation logic.
 */
public final class WaitUtils {

    private static final Logger LOG = LogManager.getLogger(WaitUtils.class);

    private WaitUtils() {}

    // ── Visibility ─────────────────────────────────────────────────────────────

    /**
     * Waits until {@code element} is visible.
     *
     * @param driver         WebDriver instance
     * @param element        element to wait for
     * @param timeoutSeconds maximum wait time
     * @return the element once visible
     */
    public static WebElement waitForVisibility(WebDriver driver,
                                               WebElement element,
                                               int timeoutSeconds) {
        return buildWait(driver, timeoutSeconds)
                .until(ExpectedConditions.visibilityOf(element));
    }

    /**
     * Waits until an element matching {@code locator} is visible.
     */
    public static WebElement waitForVisibility(WebDriver driver,
                                               By locator,
                                               int timeoutSeconds) {
        return buildWait(driver, timeoutSeconds)
                .until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    // ── Clickability ───────────────────────────────────────────────────────────

    /**
     * Waits until {@code element} is clickable (visible + enabled).
     */
    public static WebElement waitForClickability(WebDriver driver,
                                                 WebElement element,
                                                 int timeoutSeconds) {
        return buildWait(driver, timeoutSeconds)
                .until(ExpectedConditions.elementToBeClickable(element));
    }

    // ── Presence ───────────────────────────────────────────────────────────────

    /**
     * Waits until at least one element matching {@code locator} is present in
     * the DOM (not necessarily visible).
     */
    public static List<WebElement> waitForPresenceOfAll(WebDriver driver,
                                                        By locator,
                                                        int timeoutSeconds) {
        return buildWait(driver, timeoutSeconds)
                .until(ExpectedConditions.presenceOfAllElementsLocatedBy(locator));
    }

    // ── URL / Title ────────────────────────────────────────────────────────────

    /**
     * Waits until the current URL contains {@code urlFragment}.
     */
    public static void waitForUrlContains(WebDriver driver,
                                          String urlFragment,
                                          int timeoutSeconds) {
        buildWait(driver, timeoutSeconds)
                .until(ExpectedConditions.urlContains(urlFragment));
    }

    /**
     * Waits until the page title contains {@code titleFragment}.
     */
    public static void waitForTitleContains(WebDriver driver,
                                            String titleFragment,
                                            int timeoutSeconds) {
        buildWait(driver, timeoutSeconds)
                .until(ExpectedConditions.titleContains(titleFragment));
    }

    // ── Scroll ─────────────────────────────────────────────────────────────────

    /**
     * Scrolls the element into the viewport using JavaScript.
     */
    public static void scrollIntoView(WebDriver driver, WebElement element) {
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", element);
    }

    // ── Safe-check helpers ─────────────────────────────────────────────────────

    /**
     * Returns {@code true} if the element is displayed; catches
     * {@link NoSuchElementException} / {@link StaleElementReferenceException}
     * and returns {@code false} so callers do not need try-catch blocks.
     */
    public static boolean isDisplayed(WebElement element) {
        try {
            return element.isDisplayed();
        } catch (NoSuchElementException | StaleElementReferenceException e) {
            LOG.debug("Element not displayed: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Waits up to {@code timeoutSeconds} for an element to become visible and
     * returns {@code false} instead of throwing if it never appears — useful
     * for negative assertions.
     */
    public static boolean waitAndCheckVisibility(WebDriver driver,
                                                 By locator,
                                                 int timeoutSeconds) {
        try {
            waitForVisibility(driver, locator, timeoutSeconds);
            return true;
        } catch (TimeoutException | NoSuchElementException e) {
            return false;
        }
    }

    // ── Custom condition ───────────────────────────────────────────────────────

    /**
     * Waits until the page-load state reaches "complete".
     */
    public static void waitForPageLoad(WebDriver driver, int timeoutSeconds) {
        buildWait(driver, timeoutSeconds).until((ExpectedCondition<Boolean>) d -> {
            assert d != null;
            return "complete".equals(((JavascriptExecutor) d)
                    .executeScript("return document.readyState"));
        });
    }

    // ── Factory ────────────────────────────────────────────────────────────────

    private static WebDriverWait buildWait(WebDriver driver, int timeoutSeconds) {
        return new WebDriverWait(driver, Duration.ofSeconds(timeoutSeconds));
    }
}
