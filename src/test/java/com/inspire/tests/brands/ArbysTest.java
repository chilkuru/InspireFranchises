package com.inspire.tests.brands;

import com.inspire.driver.DriverManager;
import com.inspire.pages.brands.AbstractBrandPage;
import com.inspire.pages.brands.ArbysPage;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 * Test class for the Arby's Franchising page:
 * https://www.franchising.inspirebrands.com/arbys
 *
 * <p>
 * Inherits <strong>all 12 common brand test cases</strong> (TC-B-01 to
 * TC-B-12) from {@link AbstractBrandTest} and adds Arby's-specific tests
 * (TC-A-01 to TC-A-10).
 *
 * <p>
 * Run only Arby's tests:
 * 
 * <pre>
 *   mvn test -P arbys
 * </pre>
 */
public class ArbysTest extends AbstractBrandTest {

    // ── Template method ────────────────────────────────────────────────────────

    @Override
    protected AbstractBrandPage getBrandPage() {
        return new ArbysPage(DriverManager.getDriver());
    }

    /** Typed convenience accessor to avoid repeated casts in Arby's tests. */
    private ArbysPage arbysPage() {
        return (ArbysPage) brandPage;
    }

    // ── TC-A-01 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify page title contains 'Arby's'", groups = { "smoke", "arbys" })
    public void TC_A_01_verifyPageTitleContainsArbys() {
        logStep("Reading page title");
        String title = arbysPage().getPageTitleText();
        logStep("Page title: '" + title + "'");
        Assert.assertTrue(
                title.contains("Arby"),
                "Page title should contain 'Arby' but was: '" + title + "'");
        logPass("Page title contains 'Arby': " + title);
    }

    // ── TC-A-02 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify the hero heading reads 'Franchise with Arby's'", groups = { "smoke", "arbys", "hero" })
    public void TC_A_02_verifyHeroHeadingIsArbys() {
        logStep("Reading hero heading");
        String heading = arbysPage().getHeroHeadingText();
        logStep("Hero heading: '" + heading + "'");
        Assert.assertTrue(
                heading.contains("Franchise with") && heading.contains("Arby"),
                "Hero heading should read 'Franchise with Arby's' but was: '" + heading + "'");
        logPass("Hero heading is correct: '" + heading + "'");
    }

    // ── TC-A-03 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify the 'Why Arby's?' section heading is displayed", groups = { "regression", "arbys" })
    public void TC_A_03_verifyWhyArbysHeadingDisplayed() {
        logStep("Checking 'Why Arby's?' heading");
        Assert.assertTrue(
                arbysPage().isWhyArbysHeadingDisplayed(),
                "'Why Arby's?' heading should be visible on the Arby's page");
        logPass("'Why Arby's?' heading is displayed");
    }

    // ── TC-A-04 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify award recognitions (Entrepreneur, Top Food, Franchise 500) are listed", groups = {
            "regression", "arbys" })
    public void TC_A_04_verifyAwardsDisplayed() {
        logStep("Checking Entrepreneur award text");
        Assert.assertTrue(
                arbysPage().isEntrepreneurAwardDisplayed(),
                "Entrepreneur award text should be visible");

        logStep("Checking Top Food Franchise award text");
        Assert.assertTrue(
                arbysPage().isTopFoodFranchiseAwardDisplayed(),
                "Top Food Franchise award text should be visible");

        logStep("Checking Franchise 500 award text");
        Assert.assertTrue(
                arbysPage().isFranchise500AwardDisplayed(),
                "Franchise 500 award text should be visible");

        logPass("All three Arby's award recognitions are displayed");
    }

    // ── TC-A-05 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify liquid assets requirement of $500,000 is displayed", groups = { "regression", "arbys",
            "qualification" })
    public void TC_A_05_verifyLiquidAssetsRequirement() {
        logStep("Checking $500,000 liquid assets requirement");
        Assert.assertTrue(
                arbysPage().isLiquidAssetsRequirementDisplayed(),
                "Liquid assets requirement of $500,000 should be visible");
        logPass("$500,000 liquid assets requirement is displayed");
    }

    // ── TC-A-06 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify net worth requirement of $1,000,000 is displayed", groups = { "regression", "arbys",
            "qualification" })
    public void TC_A_06_verifyNetWorthRequirement() {
        logStep("Checking $1,000,000 net worth requirement");
        Assert.assertTrue(
                arbysPage().isNetWorthRequirementDisplayed(),
                "Net worth requirement of $1,000,000 should be visible");
        logPass("$1,000,000 net worth requirement is displayed");
    }

    // ── TC-A-07 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify all three restaurant formats (Free Standing, Endcap, Small Format) are displayed", groups = {
            "regression", "arbys", "formats" })
    public void TC_A_07_verifyRestaurantFormatsDisplayed() {
        logStep("Checking 'Free Standing' format");
        Assert.assertTrue(
                arbysPage().isFreeStandingFormatDisplayed(),
                "'Free Standing' format label should be visible");

        logStep("Checking 'Endcap' format");
        Assert.assertTrue(
                arbysPage().isEndcapFormatDisplayed(),
                "'Endcap' format label should be visible");

        logStep("Checking 'Small Format'");
        Assert.assertTrue(
                arbysPage().isSmallFormatDisplayed(),
                "'Small Format' label should be visible");

        logPass("All three Arby's restaurant formats are displayed");
    }

    // ── TC-A-08 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify 'Anything is possible with Arby's' section is displayed", groups = { "regression",
            "arbys" })
    public void TC_A_08_verifyAnythingIsPossibleSection() {
        logStep("Checking 'Anything is possible with Arby's' section");
        Assert.assertTrue(
                arbysPage().isAnythingIsPossibleSectionDisplayed(),
                "'Anything is possible with Arby's' section should be visible");
        logPass("'Anything is possible with Arby's' section is displayed");
    }

    // ── TC-A-09 ────────────────────────────────────────────────────────────────

    @Test(description = "Verify the restaurant count factoid ('3,500 restaurants') is displayed", groups = {
            "regression", "arbys" })
    public void TC_A_09_verifyRestaurantCountDisplayed() {
        logStep("Checking restaurant count text (3,500 restaurants)");
        Assert.assertTrue(
                arbysPage().isRestaurantCountDisplayed(),
                "'3,500 restaurants' factoid should be visible on the Arby's page");
        logPass("Restaurant count '3,500 restaurants' is displayed");
    }
}
