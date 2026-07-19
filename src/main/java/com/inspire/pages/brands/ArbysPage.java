package com.inspire.pages.brands;

import com.inspire.config.ConfigReader;
import com.inspire.enums.Brand;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * Page Object for the Arby's Franchising page:
 * https://www.franchising.inspirebrands.com/arbys
 *
 * <p>
 * Extends {@link AbstractBrandPage} to inherit all common brand-page
 * locators and behaviour. This class adds only <em>Arby's-specific</em>
 * locators and methods.
 *
 * <p>
 * To add another brand: create a similar class that extends
 * {@link AbstractBrandPage}, add its enum entry in {@link Brand}, create its
 * properties file and wire it in {@link com.inspire.factory.BrandPageFactory}.
 * Zero existing classes need modification (Open/Closed Principle).
 */
public class ArbysPage extends AbstractBrandPage {

    // ── Arby's-specific locators ───────────────────────────────────────────────

    // "Why Arby's?" heading — uses brand.why.heading from config
    // (split on apostrophe to avoid straight-vs-curly mismatch in XPath)
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Arby')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Arby')])[1]")
    private WebElement whyArbysHeading;

    // "We Have The Meats" brand tagline (not in properties — Arby's-only constant)
    @FindBy(xpath = "//*[contains(normalize-space(.), 'We Have The Meats')]"
            + "[not(self::script)]")
    private WebElement weHaveTheMeatsText;

    // GET STARTED link – must include brand query param
    @FindBy(xpath = "//a[contains(@href, 'franchise-with-us') and contains(@href, 'Arby')]")
    private WebElement arbysGetStartedLink;

    // NOTE: awards, qualification figures, formats, factoid, and
    // 'Anything is possible' section are resolved dynamically from
    // ConfigReader so the XPath is driven by brands/arbys.properties
    // rather than hardcoded strings.

    // ── Constructor ────────────────────────────────────────────────────────────

    public ArbysPage(WebDriver driver) {
        super(driver);
    }

    // ── AbstractBrandPage implementation ───────────────────────────────────────

    @Override
    public String getBrandPagePath() {
        return "/" + Brand.ARBYS.getUrlSlug(); // "/arbys"
    }

    @Override
    public String getBrandDisplayName() {
        return Brand.ARBYS.getDisplayName(); // "Arby's"
    }

    // ── Arby's-specific public methods ─────────────────────────────────────────

    /**
     * @return {@code true} if "Why Arby's?" heading is visible
     */
    public boolean isWhyArbysHeadingDisplayed() {
        return isVisibleAfterWait(whyArbysHeading);
    }

    /**
     * @return {@code true} if the Entrepreneur award line is visible
     */
    public boolean isEntrepreneurAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.entrepreneur", "Entrepreneur");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /**
     * @return {@code true} if the Franchise 500 award line is visible
     */
    public boolean isFranchise500AwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.franchise500", "Franchise 500");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /**
     * @return {@code true} if the Top Food Franchise award line is visible
     */
    public boolean isTopFoodFranchiseAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.topfood", "Top Food");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /**
     * @return {@code true} if "We Have The Meats®" text is visible
     */
    public boolean isWeHaveTheMeatsTextDisplayed() {
        return isVisibleAfterWait(weHaveTheMeatsText);
    }

    /**
     * @return {@code true} if the liquid assets requirement is visible
     */
    public boolean isLiquidAssetsRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.liquid.assets", "500,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /**
     * @return {@code true} if the net worth requirement is visible
     */
    public boolean isNetWorthRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.net.worth", "1,000,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /**
     * @return {@code true} if the "Free Standing" format card is visible
     */
    public boolean isFreeStandingFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.freestanding", "Free Standing");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Endcap" format card is visible
     */
    public boolean isEndcapFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.endcap", "Endcap");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Small Format" format card is visible
     */
    public boolean isSmallFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.smallformat", "Small Format");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Anything is possible with Arby's" section is visible
     */
    public boolean isAnythingIsPossibleSectionDisplayed() {
        // brand.section.anything.possible = "Anything is possible with Arby's"
        // Split at the apostrophe (curly U+2019 or straight U+0027) to avoid
        // XPath apostrophe escaping issues
        String val = ConfigReader.getInstance().get(
                "brand.section.anything.possible", "Anything is possible");
        String safeText = val.split("['\u2019]")[0].trim(); // e.g. "Anything is possible with Arby"
        return isVisibleAfterWait(findByContainsText(safeText));
    }

    /**
     * Returns the href of the GET STARTED link (should contain brand query param).
     *
     * @return href attribute value, e.g. "…/franchise-with-us?brand=Arby%27s"
     */
    public String getGetStartedLinkHref() {
        return arbysGetStartedLink.getAttribute("href");
    }

    /**
     * @return {@code true} if the restaurant-count factoid is visible
     */
    public boolean isRestaurantCountDisplayed() {
        String count = ConfigReader.getInstance().get("brand.restaurant.count", "3,500");
        return isVisibleAfterWait(findByContainsText(count));
    }
}
