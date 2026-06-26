package com.inspire.tests.brands;

import com.inspire.base.BaseTest;
import com.inspire.constants.AppConstants;
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
     * TC-B-02: Verify the hero heading follows the "Franchise with [Brand]"
     * pattern.
     */
    @org.testng.annotations.Test(description = "Verify the hero heading contains 'Franchise with [Brand Name]'", groups = {
            "smoke", "brand-common", "hero" })
    public void TC_B_02_verifyHeroHeadingDisplayed() {
        logStep("Checking hero heading visibility");
        Assert.assertTrue(
                brandPage().getHeroHeadingText().contains(AppConstants.BRAND_HERO_HEADING_PREFIX),
                "Hero heading should start with 'Franchise with' but was: "
                        + brandPage().getHeroHeadingText());
        logPass("Hero heading displayed: '" + brandPage().getHeroHeadingText() + "'");
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

    /**
     * TC-B-04: Verify clicking GET STARTED navigates to the franchise enquiry form.
     */
    @org.testng.annotations.Test(description = "Verify GET STARTED button navigates to the franchise enquiry form", groups = {
            "smoke", "brand-common", "navigation" })
    public void TC_B_04_verifyGetStartedNavigatesToForm() {
        logStep("Clicking GET STARTED button");
        String url = brandPage().clickGetStartedAndGetUrl();
        logStep("Navigated to: " + url);
        Assert.assertTrue(
                url.contains(AppConstants.FRANCHISE_FORM_PATH),
                "GET STARTED should navigate to '" + AppConstants.FRANCHISE_FORM_PATH
                        + "' but navigated to: " + url);
        logPass("GET STARTED navigates to form: " + url);
    }

    /**
     * TC-B-05: Verify the "Why [Brand]?" section is displayed.
     */
    @org.testng.annotations.Test(description = "Verify 'Why [Brand]?' section is displayed", groups = { "regression",
            "brand-common" })
    public void TC_B_05_verifyWhyBrandSectionDisplayed() {
        logStep("Checking 'Why " + brandPage().getBrandDisplayName() + "?' section");
        Assert.assertTrue(
                brandPage().isWhyBrandSectionDisplayed(),
                "'Why " + brandPage().getBrandDisplayName() + "?' section should be visible");
        logPass("'Why " + brandPage().getBrandDisplayName() + "?' section is displayed");
    }

    /**
     * TC-B-06: Verify the "Here's how we help" support section is displayed.
     */
    @org.testng.annotations.Test(description = "Verify 'Here's how we help' section is displayed", groups = {
            "regression", "brand-common" })
    public void TC_B_06_verifyHelpSectionDisplayed() {
        logStep("Checking 'Here's how we help' section");
        Assert.assertTrue(
                brandPage().isHelpSectionDisplayed(),
                "'Here's how we help' section should be visible");
        logPass("'Here's how we help' section is displayed");
    }

    /**
     * TC-B-07: Verify Training & Support, Marketing & PR, and Technology &
     * Innovation subsections are all present.
     */
    @org.testng.annotations.Test(description = "Verify all three support pillars are displayed: Training, Marketing, Technology", groups = {
            "regression", "brand-common" })
    public void TC_B_07_verifySupportPillarsDisplayed() {
        logStep("Checking support pillar subsections");
        Assert.assertTrue(
                brandPage().isTrainingSupportDisplayed(),
                "Training & Support subsection should be visible");
        logStep("Training & Support is visible");

        Assert.assertTrue(
                brandPage().isMarketingPRDisplayed(),
                "Marketing & PR subsection should be visible");
        logStep("Marketing & PR is visible");

        Assert.assertTrue(
                brandPage().isTechInnovationDisplayed(),
                "Technology & Innovation subsection should be visible");
        logPass("All three support pillars are displayed");
    }

    /**
     * TC-B-08: Verify the franchise qualification requirements section is visible.
     */
    @org.testng.annotations.Test(description = "Verify the franchise qualification requirements section is displayed", groups = {
            "regression", "brand-common" })
    public void TC_B_08_verifyQualificationSectionDisplayed() {
        logStep("Checking qualification requirements section");
        Assert.assertTrue(
                brandPage().isQualificationSectionDisplayed(),
                "Qualification requirements section should be visible");
        logPass("Qualification requirements section is displayed");
    }

    /**
     * TC-B-09: Verify the "What's next?" section heading is displayed.
     */
    @org.testng.annotations.Test(description = "Verify the 'What's next?' section is displayed", groups = {
            "regression", "brand-common" })
    public void TC_B_09_verifyWhatNextSectionDisplayed() {
        logStep("Checking 'What's next?' section");
        Assert.assertTrue(
                brandPage().isWhatNextSectionDisplayed(),
                "'What's next?' section should be visible");
        logPass("'What's next?' section is displayed");
    }

    /**
     * TC-B-10: Verify all five franchise process steps (Apply → Discuss →
     * Review → Interview → Sign) are displayed.
     */
    @org.testng.annotations.Test(description = "Verify all 5 franchise process steps (Apply, Discuss, Review, Interview, Sign) are displayed", groups = {
            "regression", "brand-common" })
    public void TC_B_10_verifyAllFiveStepsDisplayed() {
        logStep("Checking all five franchise process steps");
        Assert.assertTrue(
                brandPage().areFranchiseStepsDisplayed(),
                "All five franchise process steps should be visible");
        logPass("All five franchise process steps are displayed");
    }

    /**
     * TC-B-11: Verify the page footer is visible.
     */
    @org.testng.annotations.Test(description = "Verify the page footer is displayed", groups = { "regression",
            "brand-common", "footer" })
    public void TC_B_11_verifyFooterDisplayed() {
        logStep("Checking footer visibility");
        Assert.assertTrue(
                brandPage().isFooterDisplayed(),
                "Footer should be visible on the brand page");
        logPass("Footer is displayed");
    }

    /**
     * TC-B-12: Verify the cross-brand promotion links section is visible.
     */
    @org.testng.annotations.Test(description = "Verify the 'Or franchise with any of Inspire's brands' cross-brand section is displayed", groups = {
            "regression", "brand-common", "footer" })
    public void TC_B_12_verifyOtherBrandsLinksDisplayed() {
        logStep("Checking cross-brand promotion links");
        Assert.assertTrue(
                brandPage().isOtherBrandsLinksDisplayed(),
                "Cross-brand promotion links should be visible on the brand page");
        logPass("Cross-brand promotion links are displayed");
    }
}
