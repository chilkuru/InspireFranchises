package com.inspire.base;

import com.inspire.config.ConfigReader;
import com.inspire.utils.WaitUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.*;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Abstract base class for all Page Objects.
 *
 * <p>
 * Responsibilities (Single Responsibility within the page layer):
 * <ul>
 * <li>Initialises {@link PageFactory} so subclasses can declare
 * {@code @FindBy}-annotated fields.
 * <li>Exposes protected helper methods (click, type, scroll, getText,
 * isDisplayed) that every page object needs.
 * <li>Holds a reference to the configured explicit-wait timeout.
 * </ul>
 *
 * <p>
 * Subclasses must <strong>not</strong> duplicate wait or interaction
 * boilerplate – delegate to the helpers here.
 */
public abstract class BasePage {

    protected final Logger log = LogManager.getLogger(getClass());

    protected final WebDriver driver;
    protected final int waitSec;

    // ── constructor ────────────────────────────────────────────────────────────

    protected BasePage(WebDriver driver) {
        this.driver = driver;
        this.waitSec = ConfigReader.getInstance().getExplicitWaitSec();
        // Initialise all @FindBy / @FindBys fields in the concrete subclass
        PageFactory.initElements(driver, this);
    }

    // ── Navigation helpers ─────────────────────────────────────────────────────

    /**
     * Navigates to the given URL, waits for page-load to complete, then
     * automatically dismisses the cookie consent banner if it is present.
     *
     * <p>
     * Fresh browser sessions (e.g. Maven Surefire runs) always show the
     * banner because there are no pre-existing cookies. Dismissing it here
     * ensures interactive elements below the banner are immediately clickable.
     *
     * @param url absolute URL to open
     */
    protected void navigateTo(String url) {
        log.info("Navigating to: {}", url);
        driver.get(url);
        WaitUtils.waitForPageLoad(driver, waitSec);
        dismissCookieBannerIfPresent();
    }

    /** @return the current browser URL */
    protected String getCurrentUrl() {
        return driver.getCurrentUrl();
    }

    /** @return the current page title */
    protected String getPageTitle() {
        return driver.getTitle();
    }

    // ── Element interaction helpers ────────────────────────────────────────────

    /**
     * Clicks an element after scrolling it into view and waiting for clickability.
     * Falls back to a JavaScript click when the element has zero size or is
     * otherwise
     * not interactable via a synthetic DOM event (e.g. image-only anchors).
     *
     * @param element target element
     */
    protected void click(WebElement element) {
        WaitUtils.scrollIntoView(driver, element);
        try {
            WaitUtils.waitForClickability(driver, element, waitSec).click();
        } catch (org.openqa.selenium.ElementNotInteractableException
                | org.openqa.selenium.TimeoutException e) {
            log.warn("Regular click failed ({}), falling back to JavaScript click",
                    e.getClass().getSimpleName());
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", element);
        }
    }

    /**
     * Types text into an input element (clears first).
     *
     * @param element target input
     * @param text    text to enter
     */
    protected void type(WebElement element, String text) {
        WaitUtils.waitForVisibility(driver, element, waitSec).clear();
        element.sendKeys(text);
    }

    /**
     * Returns the trimmed visible text of an element after waiting for
     * visibility.
     *
     * @param element target element
     * @return trimmed text content
     */
    protected String getText(WebElement element) {
        return WaitUtils.waitForVisibility(driver, element, waitSec).getText().trim();
    }

    /**
     * Returns {@code true} if the element is currently displayed without
     * throwing an exception for missing / stale elements.
     *
     * @param element element to check
     * @return visibility status
     */
    protected boolean isDisplayed(WebElement element) {
        return WaitUtils.isDisplayed(element);
    }

    /**
     * Scrolls the element into view, then waits for it to become visible.
     * Returns {@code false} on timeout instead of throwing.
     *
     * <p>
     * The scroll-first approach is essential for Squarespace sites which
     * use CSS scroll-triggered animations: elements below the fold start with
     * {@code opacity:0} or a CSS transform and only become visible after
     * the browser scrolls them into the viewport.
     */
    protected boolean isVisibleAfterWait(WebElement element) {
        try {
            WaitUtils.scrollIntoView(driver, element);
        } catch (Exception ignored) {
            // element may not be in DOM yet — let waitForVisibility handle it
        }
        try {
            WaitUtils.waitForVisibility(driver, element, waitSec);
            return element.isDisplayed();
        } catch (org.openqa.selenium.TimeoutException
                | org.openqa.selenium.NoSuchElementException
                | org.openqa.selenium.StaleElementReferenceException e) {
            return false;
        }
    }

    /**
     * Waits for an element located by {@code locator} to contain {@code text}
     * and returns it.
     */
    protected WebElement waitForTextContains(By locator, String text) {
        return new WebDriverWait(driver, Duration.ofSeconds(waitSec))
                .until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    /**
     * Finds all elements matching {@code locator} within the current page.
     *
     * @param locator the By locator
     * @return list of matching elements (may be empty)
     */
    protected List<WebElement> findAll(By locator) {
        return driver.findElements(locator);
    }

    /**
     * Checks whether any element on the page contains the given text using
     * a case-insensitive XPath search.
     *
     * @param text text fragment to look for
     * @return {@code true} if at least one element contains the text
     */
    protected boolean pageContainsText(String text) {
        // Use normalize-space(.) to capture text in nested elements (e.g. Squarespace
        // spans).
        // Wrap the search term in double quotes so apostrophes in brand names
        // ("Arby's")
        // do not break the XPath string delimiter.
        String lowerText = text.toLowerCase().replace("\"", "'"); // sanitise any double-quotes
        List<WebElement> elements = driver.findElements(
                By.xpath("//*[contains(translate(normalize-space(.), "
                        + "'ABCDEFGHIJKLMNOPQRSTUVWXYZ', "
                        + "'abcdefghijklmnopqrstuvwxyz'), \""
                        + lowerText + "\")]"));
        return !elements.isEmpty();
    }

    /**
     * Scrolls to the bottom of the page – useful before asserting footer
     * content that may be inside a lazy-loaded viewport.
     */
    protected void scrollToBottom() {
        ((JavascriptExecutor) driver)
                .executeScript("window.scrollTo(0, document.body.scrollHeight);");
    }

    /**
     * Hovers over an element using JavaScript (fallback for environments where
     * Actions-based hover is unreliable).
     */
    protected void hoverOver(WebElement element) {
        WaitUtils.scrollIntoView(driver, element);
        ((JavascriptExecutor) driver).executeScript(
                "arguments[0].dispatchEvent(new MouseEvent('mouseover', {bubbles: true}));",
                element);
    }

    /**
     * Clicks the "Accept All" cookie consent button if the banner is visible.
     * Uses a short timeout so it does not slow down tests when no banner appears.
     */
    protected void dismissCookieBannerIfPresent() {
        try {
            // The banner appears within ~2 s; use a short wait to avoid delaying every test
            org.openqa.selenium.WebElement acceptBtn = new org.openqa.selenium.support.ui.WebDriverWait(
                    driver, java.time.Duration.ofSeconds(4))
                    .until(org.openqa.selenium.support.ui.ExpectedConditions
                            .elementToBeClickable(org.openqa.selenium.By.xpath(
                                    "//a[contains(normalize-space(.),'Accept All')]"
                                            + " | //button[contains(normalize-space(.),'Accept All')]")));
            acceptBtn.click();
            log.info("Cookie consent banner dismissed");
        } catch (Exception e) {
            // No banner present — normal on repeat visits
            log.debug("No cookie banner detected: {}", e.getClass().getSimpleName());
        }
    }
}
