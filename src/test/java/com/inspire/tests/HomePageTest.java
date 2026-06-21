package com.inspire.tests;

import com.inspire.base.BaseTest;
import com.inspire.constants.AppConstants;
import com.inspire.driver.DriverManager;
import com.inspire.enums.Brand;
import com.inspire.pages.HomePage;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

/**
 * Test class for the Inspire Brands Franchising home page.
 *
 * <p>TC-H-01 through TC-H-10 cover critical user journeys on the home page.
 * These tests are brand-agnostic and run regardless of the {@code active.brand}
 * setting.
 *
 * <p>Each test method:
 * <ol>
 *   <li>Has a unique TC ID in its name for traceability.
 *   <li>Carries a {@code description} attribute that appears in the Extent report.
 *   <li>Uses {@code groups} for selective execution via TestNG.
 * </ol>
 */
public class HomePageTest extends BaseTest {

    private HomePage homePage;

    // ── Setup ──────────────────────────────────────────────────────────────────

    @BeforeMethod(alwaysRun = true)
    public void openHomePage() {
        homePage = new HomePage(DriverManager.getDriver());
        homePage.open();
    }

    // ── TC-H-01 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the home page loads successfully and the URL is correct",
        groups = {"smoke", "home"}
    )
    public void TC_H_01_verifyHomePageLoads() {
        logStep("Verifying home page URL");
        String currentUrl = DriverManager.getDriver().getCurrentUrl();
        Assert.assertTrue(
            currentUrl.contains("franchising.inspirebrands.com"),
            "URL should contain 'franchising.inspirebrands.com' but was: " + currentUrl
        );
        logPass("Home page URL verified: " + currentUrl);
    }

    // ── TC-H-02 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the hero section heading 'Anything is Possible' is displayed",
        groups = {"smoke", "home", "hero"}
    )
    public void TC_H_02_verifyHeroHeadingDisplayed() {
        logStep("Checking hero heading visibility");
        Assert.assertTrue(
            homePage.isHeroHeadingDisplayed(),
            "Hero heading 'Anything is Possible' should be visible on home page"
        );
        logPass("Hero heading is displayed");
    }

    // ── TC-H-03 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the hero heading text is exactly 'Anything is Possible'",
        groups = {"regression", "home", "hero"}
    )
    public void TC_H_03_verifyHeroHeadingText() {
        logStep("Reading hero heading text");
        String headingText = homePage.getHeroHeadingText();
        logStep("Hero heading text: '" + headingText + "'");
        Assert.assertTrue(
            headingText.contains(AppConstants.HOME_HERO_HEADING),
            "Hero heading should contain '" + AppConstants.HOME_HERO_HEADING
            + "' but was: '" + headingText + "'"
        );
        logPass("Hero heading text matches expected value");
    }

    // ── TC-H-04 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the hero 'GET STARTED' CTA button is displayed",
        groups = {"smoke", "home", "hero"}
    )
    public void TC_H_04_verifyHeroCTAButtonDisplayed() {
        logStep("Checking 'GET STARTED' button visibility");
        Assert.assertTrue(
            homePage.isHeroGetStartedButtonDisplayed(),
            "'GET STARTED' button should be visible in hero section"
        );
        logPass("'GET STARTED' CTA button is displayed");
    }

    // ── TC-H-05 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify clicking 'GET STARTED' navigates to the franchise enquiry form",
        groups = {"smoke", "home", "navigation"}
    )
    public void TC_H_05_verifyGetStartedNavigatesToForm() {
        logStep("Clicking 'GET STARTED' button");
        String resultUrl = homePage.clickHeroGetStartedAndGetUrl();
        logStep("Navigated to: " + resultUrl);
        Assert.assertTrue(
            resultUrl.contains(AppConstants.FRANCHISE_FORM_PATH),
            "Clicking GET STARTED should navigate to '" + AppConstants.FRANCHISE_FORM_PATH
            + "' but navigated to: " + resultUrl
        );
        logPass("'GET STARTED' correctly navigates to franchise form: " + resultUrl);
    }

    // ── TC-H-06 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the 'Grow with Inspire's Iconic Brands' section is visible",
        groups = {"regression", "home"}
    )
    public void TC_H_06_verifyBrandsSectionDisplayed() {
        logStep("Checking brands section heading visibility");
        Assert.assertTrue(
            homePage.isBrandsSectionDisplayed(),
            "'Grow with Inspire's Iconic Brands' section should be visible"
        );
        logPass("Brands section is displayed");
    }

    // ── TC-H-07 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify 'Our Brands' navigation menu contains 'Arby's'",
        groups = {"regression", "home", "navigation"}
    )
    public void TC_H_07_verifyOurBrandsDropdownContainsArbys() {
        logStep("Opening 'Our Brands' dropdown and checking for Arby's");
        Assert.assertTrue(
            homePage.isBrandInDropdown(Brand.ARBYS.getDisplayName()),
            "Arby's should be listed in the 'Our Brands' dropdown"
        );
        logPass("Arby's found in 'Our Brands' dropdown");
    }

    // ── TC-H-08 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify Arby's brand link on the home page body navigates to the Arby's page",
        groups = {"regression", "home", "navigation"}
    )
    public void TC_H_08_verifyArbysLinkNavigatesToArbysPage() {
        logStep("Clicking Arby's brand link on home page body");
        String resultUrl = homePage.clickArbysBodyLink();
        logStep("Navigated to: " + resultUrl);
        Assert.assertTrue(
            resultUrl.contains("/arbys"),
            "Arby's link should navigate to '/arbys' but navigated to: " + resultUrl
        );
        logPass("Arby's link navigates correctly to: " + resultUrl);
    }

    // ── TC-H-09 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the page footer is displayed with company name",
        groups = {"regression", "home", "footer"}
    )
    public void TC_H_09_verifyFooterDisplayed() {
        logStep("Checking footer visibility");
        Assert.assertTrue(
            homePage.isFooterDisplayed(),
            "Footer should be visible on the home page"
        );
        Assert.assertTrue(
            homePage.isFooterCompanyNameDisplayed(),
            "Footer should display 'INSPIRE BRANDS FRANCHISING'"
        );
        logPass("Footer is displayed with company name");
    }

    // ── TC-H-10 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the LinkedIn link is present in the footer",
        groups = {"regression", "home", "footer"}
    )
    public void TC_H_10_verifyLinkedInLinkInFooter() {
        logStep("Checking LinkedIn link in footer");
        Assert.assertTrue(
            homePage.isLinkedInLinkPresent(),
            "LinkedIn link should be present in the footer"
        );
        String href = homePage.getLinkedInHref();
        logStep("LinkedIn href: " + href);
        Assert.assertTrue(
            href.contains(AppConstants.FOOTER_LINKEDIN_URL),
            "LinkedIn link should point to linkedin.com but was: " + href
        );
        logPass("LinkedIn link present and points to: " + href);
    }

    // ── TC-H-11 ────────────────────────────────────────────────────────────────

    @Test(
        description = "Verify the 'How do I become a franchisee?' section is present",
        groups = {"regression", "home"}
    )
    public void TC_H_11_verifyHowToFranchiseeSection() {
        logStep("Checking 'How do I become a franchisee?' section");
        Assert.assertTrue(
            homePage.isHowToFranchiseeSectionDisplayed(),
            "'How do I become a franchisee?' section should be visible"
        );
        logPass("'How do I become a franchisee?' section is displayed");
    }
}
