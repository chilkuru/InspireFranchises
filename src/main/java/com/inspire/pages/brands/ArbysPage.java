package com.inspire.pages.brands;

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

    // "Why Arby's?" heading — avoid straight-vs-curly apostrophe by splitting
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Arby')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Arby')])[1]")
    private WebElement whyArbysHeading;

    // Awards — use normalize-space(.) to match text inside nested spans
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Entrepreneur')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement entrepreneurAward;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Franchise 500')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement franchise500Award;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Top Food')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement topFoodFranchiseAward;

    // "We Have The Meats" brand tagline
    @FindBy(xpath = "//*[contains(normalize-space(.), 'We Have The Meats')]"
            + "[not(self::script)]")
    private WebElement weHaveTheMeatsText;

    // Qualification requirements — use normalize-space(.) for nested span text
    @FindBy(xpath = "//*[contains(normalize-space(.), '500,000')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement liquidAssetsText;

    @FindBy(xpath = "//*[contains(normalize-space(.), '1,000,000')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement netWorthText;

    // Format type labels — use contains() to handle nested span text
    @FindBy(xpath = "//h1[contains(normalize-space(.), 'Free Standing')]"
            + " | //h2[contains(normalize-space(.), 'Free Standing')]"
            + " | //h3[contains(normalize-space(.), 'Free Standing')]"
            + " | //h4[contains(normalize-space(.), 'Free Standing')]")
    private WebElement freeStandingFormat;

    @FindBy(xpath = "//h1[contains(normalize-space(.), 'Endcap')]"
            + " | //h2[contains(normalize-space(.), 'Endcap')]"
            + " | //h3[contains(normalize-space(.), 'Endcap')]"
            + " | //h4[contains(normalize-space(.), 'Endcap')]")
    private WebElement endcapFormat;

    @FindBy(xpath = "//h1[contains(normalize-space(.), 'Small Format')]"
            + " | //h2[contains(normalize-space(.), 'Small Format')]"
            + " | //h3[contains(normalize-space(.), 'Small Format')]"
            + " | //h4[contains(normalize-space(.), 'Small Format')]")
    private WebElement smallFormat;

    // "Anything is possible with Arby's" — avoid apostrophe in "Arby's"
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Anything is possible')"
            + " and contains(normalize-space(.), 'Arby')]"
            + "[not(self::script)]")
    private WebElement anythingIsPossibleSection;

    // GET STARTED link – must include brand query param
    @FindBy(xpath = "//a[contains(@href, 'franchise-with-us') and contains(@href, 'Arby')]")
    private WebElement arbysGetStartedLink;

    // "3,500 restaurants" factoid in the hero sub-description
    @FindBy(xpath = "//*[contains(normalize-space(text()), '3,500')]"
            + "[not(self::script)]")
    private WebElement restaurantCountText;

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
        return isVisibleAfterWait(entrepreneurAward);
    }

    /**
     * @return {@code true} if the Franchise 500 award line is visible
     */
    public boolean isFranchise500AwardDisplayed() {
        return isVisibleAfterWait(franchise500Award);
    }

    /**
     * @return {@code true} if the Top Food Franchise award line is visible
     */
    public boolean isTopFoodFranchiseAwardDisplayed() {
        return isVisibleAfterWait(topFoodFranchiseAward);
    }

    /**
     * @return {@code true} if "We Have The Meats®" text is visible
     */
    public boolean isWeHaveTheMeatsTextDisplayed() {
        return isVisibleAfterWait(weHaveTheMeatsText);
    }

    /**
     * @return {@code true} if the "$500,000 liquid assets" requirement is visible
     */
    public boolean isLiquidAssetsRequirementDisplayed() {
        return isVisibleAfterWait(liquidAssetsText);
    }

    /**
     * @return {@code true} if the "$1,000,000 net worth" requirement is visible
     */
    public boolean isNetWorthRequirementDisplayed() {
        return isVisibleAfterWait(netWorthText);
    }

    /**
     * @return {@code true} if the "Free Standing" format card is visible
     */
    public boolean isFreeStandingFormatDisplayed() {
        return isVisibleAfterWait(freeStandingFormat);
    }

    /**
     * @return {@code true} if the "Endcap" format card is visible
     */
    public boolean isEndcapFormatDisplayed() {
        return isVisibleAfterWait(endcapFormat);
    }

    /**
     * @return {@code true} if the "Small Format" format card is visible
     */
    public boolean isSmallFormatDisplayed() {
        return isVisibleAfterWait(smallFormat);
    }

    /**
     * @return {@code true} if the "Anything is possible with Arby's" section is
     *         visible
     */
    public boolean isAnythingIsPossibleSectionDisplayed() {
        return isVisibleAfterWait(anythingIsPossibleSection);
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
     * @return {@code true} if the restaurant-count ("3,500 restaurants") text is
     *         visible
     */
    public boolean isRestaurantCountDisplayed() {
        return isVisibleAfterWait(restaurantCountText);
    }
}
