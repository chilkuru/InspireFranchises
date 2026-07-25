package com.inspire.tests.brands;

import com.inspire.base.BaseTest;
import com.inspire.driver.DriverManager;
import com.inspire.pages.brands.AbstractBrandPage;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

/**
 * Abstract base class for brand-specific test classes.
 *
 * <p>
 * Contains all <em>common</em> test cases that apply to every brand page on
 * the Inspire Brands Franchising website (TC-B-01 … TC-B-12). Concrete brand
 * test classes (e.g. {@link ArbysTest}) extend this class and automatically
 * inherit all common tests plus add brand-specific ones.
 *
 * <p>
 * Open/Closed Principle: adding a new brand test class does not require
 * modifying this class. Simply extend it and add brand-specific tests.
 *
 * <p>
 * Template Method Pattern: {@link #getBrandPage()} is the abstract hook that
 * subclasses implement to supply the correct page object.
 */
public abstract class AbstractBrandTest extends BaseTest {

    /**
     * Thread-local brand page – each parallel thread gets its own isolated
     * instance.
     * Prevents race conditions when TestNG runs @Test methods concurrently on the
     * same class instance (parallel="methods").
     */
    private final ThreadLocal<AbstractBrandPage> brandPageLocal = new ThreadLocal<>();

    /** Returns the brand page object for the currently executing thread. */
    protected AbstractBrandPage brandPage() {
        return brandPageLocal.get();
    }

    // ── Template method ────────────────────────────────────────────────────────

    /**
     * Subclasses implement this to return their concrete page object.
     * Called by {@link #openBrandPage()} before each test method.
     */
    protected abstract AbstractBrandPage getBrandPage();

    // ── Setup ──────────────────────────────────────────────────────────────────

    @BeforeMethod(alwaysRun = true)
    public void openBrandPage() {
        AbstractBrandPage page = getBrandPage();
        page.open();
        brandPageLocal.set(page);
    }

    @AfterMethod(alwaysRun = true)
    public void cleanupBrandPage() {
        brandPageLocal.remove();
    }

    // ── Common Brand Test Cases ────────────────────────────────────────────────
    // Intentionally limited to 2 fast smoke checks so that running a brand suite
    // (e.g. -P arbys) does not incur the full common-section cost on every run.
    // Deeper section/footer/navigation coverage lives in the brand-specific test
    // class (ArbysTest etc.) where it can be tuned per brand.

    /**
     * TC-B-01: Verify the brand page loads at the correct URL.
     */
    @org.testng.annotations.Test(description = "Verify the brand page loads successfully at its expected URL", groups = {
            "smoke", "brand-common" })
    public void TC_B_01_verifyBrandPageLoads() {
        logStep("Verifying brand page URL for: " + brandPage().getBrandDisplayName());
        Assert.assertTrue(
                brandPage().isOnBrandPage(),
                "URL should contain '" + brandPage().getBrandPageUrl()
                        + "' but was: " + DriverManager.getDriver().getCurrentUrl());
        logPass("Brand page loaded at correct URL: " + DriverManager.getDriver().getCurrentUrl());
    }

    /**
     * TC-B-03: Verify the hero "GET STARTED" CTA button is displayed.
     */
    @org.testng.annotations.Test(description = "Verify the hero 'GET STARTED' call-to-action button is displayed", groups = {
            "smoke", "brand-common", "hero" })
    public void TC_B_03_verifyGetStartedButtonDisplayed() {
        logStep("Checking GET STARTED button visibility");
        Assert.assertTrue(
                brandPage().isGetStartedButtonDisplayed(),
                "GET STARTED button should be visible on the brand hero section");
        logPass("GET STARTED button is displayed");
    }
}
