package com.inspire.tests.brands;

import com.inspire.driver.DriverManager;
import com.inspire.pages.brands.AbstractBrandPage;
import com.inspire.pages.brands.BaskinRobbinsPage;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * Test class for the Baskin-Robbins Franchising page:
 * https://www.franchising.inspirebrands.com/baskin-robbins
 *
 * <p>Inherits <strong>all 12 common brand test cases</strong> (TC-B-01 to TC-B-12)
 * from {@link AbstractBrandTest} and adds Baskin-Robbins-specific tests
 * (TC-BR-01 to TC-BR-10).
 *
 * <p>Run only Baskin-Robbins tests:
 * <pre>
 *   .\mvnw.cmd clean test -P baskin-robbins
 * </pre>
 */
public class BaskinRobbinsTest extends AbstractBrandTest {

    // ── Template method ────────────────────────────────────────────────────────

    @Override
    protected AbstractBrandPage getBrandPage() {
        return new BaskinRobbinsPage(DriverManager.getDriver());
    }

    /** Typed convenience accessor to avoid repeated casts in BR-specific tests. */
    private BaskinRobbinsPage brPage() {
        return (BaskinRobbinsPage) brandPage();
    }

    // ── TC-BR-01 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify page title contains 'Baskin-Robbins'",
          groups = {"smoke", "baskin-robbins"})
    public void TC_BR_01_verifyPageTitleContainsBaskinRobbins() {
        logStep("Reading page title");
        String title = brPage().getPageTitleText();
        logStep("Page title: '" + title + "'");
        Assert.assertTrue(
            title.contains("Baskin"),
            "Page title should contain 'Baskin' but was: '" + title + "'");
        logPass("Page title contains 'Baskin': " + title);
    }

    // ── TC-BR-02 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify the hero heading reads 'Franchise with Baskin-Robbins'",
          groups = {"smoke", "baskin-robbins", "hero"})
    public void TC_BR_02_verifyHeroHeadingIsBaskinRobbins() {
        logStep("Reading hero heading");
        String heading = brPage().getHeroHeadingText();
        logStep("Hero heading: '" + heading + "'");
        Assert.assertTrue(
            heading.contains("Franchise with") && heading.contains("Baskin"),
            "Hero heading should read 'Franchise with Baskin-Robbins' but was: '" + heading + "'");
        logPass("Hero heading is correct: '" + heading + "'");
    }

    // ── TC-BR-03 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify the 'Why Baskin-Robbins?' section heading is displayed",
          groups = {"regression", "baskin-robbins"})
    public void TC_BR_03_verifyWhyBaskinRobbinsHeadingDisplayed() {
        logStep("Checking 'Why Baskin-Robbins?' heading");
        Assert.assertTrue(
            brPage().isWhyBaskinRobbinsHeadingDisplayed(),
            "'Why Baskin-Robbins?' heading should be visible");
        logPass("'Why Baskin-Robbins?' heading is displayed");
    }

    // ── TC-BR-04 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify award recognitions (Entrepreneur, Top Food Franchises, Franchise 500) are listed",
          groups = {"regression", "baskin-robbins"})
    public void TC_BR_04_verifyAwardsDisplayed() {
        logStep("Checking Entrepreneur award text");
        Assert.assertTrue(
            brPage().isEntrepreneurAwardDisplayed(),
            "Entrepreneur award text should be visible");

        logStep("Checking Top Food Franchises award text");
        Assert.assertTrue(
            brPage().isTopFoodFranchiseAwardDisplayed(),
            "Top Food Franchises award text should be visible");

        logStep("Checking Franchise 500 award text");
        Assert.assertTrue(
            brPage().isFranchise500AwardDisplayed(),
            "Franchise 500 award text should be visible");

        logPass("All three Baskin-Robbins award recognitions are displayed");
    }

    // ── TC-BR-05 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify liquid assets requirement of $100,000 is displayed",
          groups = {"regression", "baskin-robbins", "qualification"})
    public void TC_BR_05_verifyLiquidAssetsRequirement() {
        logStep("Checking $100,000 liquid assets requirement");
        Assert.assertTrue(
            brPage().isLiquidAssetsRequirementDisplayed(),
            "Liquid assets requirement of $100,000 should be visible");
        logPass("$100,000 liquid assets requirement is displayed");
    }

    // ── TC-BR-06 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify net worth requirement of $200,000 is displayed",
          groups = {"regression", "baskin-robbins", "qualification"})
    public void TC_BR_06_verifyNetWorthRequirement() {
        logStep("Checking $200,000 net worth requirement");
        Assert.assertTrue(
            brPage().isNetWorthRequirementDisplayed(),
            "Net worth requirement of $200,000 should be visible");
        logPass("$200,000 net worth requirement is displayed");
    }

    // ── TC-BR-07 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify all four restaurant formats (Free Standing, Endcap, Inline, Small Format) are displayed",
          groups = {"regression", "baskin-robbins", "formats"})
    public void TC_BR_07_verifyRestaurantFormatsDisplayed() {
        logStep("Checking 'Free Standing' format");
        Assert.assertTrue(
            brPage().isFreeStandingFormatDisplayed(),
            "'Free Standing' format label should be visible");

        logStep("Checking 'Endcap' format");
        Assert.assertTrue(
            brPage().isEndcapFormatDisplayed(),
            "'Endcap' format label should be visible");

        logStep("Checking 'Inline' format");
        Assert.assertTrue(
            brPage().isInlineFormatDisplayed(),
            "'Inline' format label should be visible");

        logStep("Checking 'Small Format'");
        Assert.assertTrue(
            brPage().isSmallFormatDisplayed(),
            "'Small Format' label should be visible");

        logPass("All four Baskin-Robbins restaurant formats are displayed");
    }

    // ── TC-BR-08 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify 'Anything is possible with Baskin-Robbins' section is displayed",
          groups = {"regression", "baskin-robbins"})
    public void TC_BR_08_verifyAnythingIsPossibleSection() {
        logStep("Checking 'Anything is possible with Baskin-Robbins' section");
        Assert.assertTrue(
            brPage().isAnythingIsPossibleSectionDisplayed(),
            "'Anything is possible with Baskin-Robbins' section should be visible");
        logPass("'Anything is possible with Baskin-Robbins' section is displayed");
    }

    // ── TC-BR-09 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify GET STARTED URL contains the Baskin-Robbins brand parameter",
          groups = {"regression", "baskin-robbins"})
    public void TC_BR_09_verifyGetStartedUrlContainsBrandParam() {
        logStep("Retrieving GET STARTED link href");
        String href = brPage().getGetStartedLinkHref();
        logStep("GET STARTED href: " + href);
        Assert.assertTrue(
            href != null && href.contains("Baskin"),
            "GET STARTED link should contain 'Baskin' brand parameter but was: " + href);
        logPass("GET STARTED link correctly contains Baskin-Robbins brand parameter: " + href);
    }

    // ── TC-BR-10 ───────────────────────────────────────────────────────────────

    @Test(description = "Verify the shop count factoid ('7,800 shops') is displayed",
          groups = {"regression", "baskin-robbins"})
    public void TC_BR_10_verifyRestaurantCountDisplayed() {
        logStep("Checking shop count text (7,800)");
        Assert.assertTrue(
            brPage().isRestaurantCountDisplayed(),
            "'7,800' shop count factoid should be visible on the Baskin-Robbins page");
        logPass("Shop count '7,800' is displayed");
    }
}
