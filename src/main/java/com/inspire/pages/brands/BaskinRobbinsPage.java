package com.inspire.pages.brands;

import com.inspire.enums.Brand;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * Page Object for the Baskin-Robbins Franchising page:
 * https://www.franchising.inspirebrands.com/baskin-robbins
 *
 * <p>
 * Extends {@link AbstractBrandPage} to inherit all common brand-page locators
 * and behaviour. This class adds only <em>Baskin-Robbins-specific</em>
 * locators and methods.
 *
 * <p>
 * Key page facts (sourced from live site):
 * <ul>
 *   <li>7,800 shops in 36 global markets (hero sub-description)
 *   <li>$100,000 liquid assets / $200,000 net worth qualification
 *   <li>Formats: Free Standing, Endcap, Inline, Small Format
 *   <li>Awards: Entrepreneur Best of the Best, Top Food Franchises, Franchise 500
 *   <li>GET STARTED href contains {@code brand=Baskin-Robbins}
 * </ul>
 */
public class BaskinRobbinsPage extends AbstractBrandPage {

    // ── Baskin-Robbins-specific locators ───────────────────────────────────────

    // "Why Baskin-Robbins?" heading — split at apostrophe-free split point
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')])[1]")
    private WebElement whyBaskinRobbinsHeading;

    // Awards
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Entrepreneur')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement entrepreneurAward;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Franchise 500')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement franchise500Award;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Top Food')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement topFoodFranchiseAward;

    // Qualification requirements
    @FindBy(xpath = "//*[contains(normalize-space(.), '100,000')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement liquidAssetsText;

    @FindBy(xpath = "//*[contains(normalize-space(.), '200,000')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement netWorthText;

    // Restaurant formats — Baskin-Robbins adds "Inline" vs Arby's
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

    @FindBy(xpath = "//h1[contains(normalize-space(.), 'Inline')]"
            + " | //h2[contains(normalize-space(.), 'Inline')]"
            + " | //h3[contains(normalize-space(.), 'Inline')]"
            + " | //h4[contains(normalize-space(.), 'Inline')]")
    private WebElement inlineFormat;

    @FindBy(xpath = "//h1[contains(normalize-space(.), 'Small Format')]"
            + " | //h2[contains(normalize-space(.), 'Small Format')]"
            + " | //h3[contains(normalize-space(.), 'Small Format')]"
            + " | //h4[contains(normalize-space(.), 'Small Format')]")
    private WebElement smallFormat;

    // "Anything is possible with Baskin-Robbins" — split to avoid hyphen issues
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Anything is possible')"
            + " and contains(normalize-space(.), 'Baskin')]"
            + "[not(self::script)]")
    private WebElement anythingIsPossibleSection;

    // GET STARTED link with Baskin-Robbins brand parameter
    @FindBy(xpath = "//a[contains(@href, 'franchise-with-us') and contains(@href, 'Baskin')]")
    private WebElement baskinGetStartedLink;

    // "7,800" shop count factoid in hero description
    @FindBy(xpath = "//*[contains(normalize-space(.), '7,800')]"
            + "[not(self::script)]")
    private WebElement restaurantCountText;

    // ── Constructor ────────────────────────────────────────────────────────────

    public BaskinRobbinsPage(WebDriver driver) {
        super(driver);
    }

    // ── AbstractBrandPage implementation ───────────────────────────────────────

    @Override
    public String getBrandPagePath() {
        return "/" + Brand.BASKIN_ROBBINS.getUrlSlug(); // "/baskin-robbins"
    }

    @Override
    public String getBrandDisplayName() {
        return Brand.BASKIN_ROBBINS.getDisplayName(); // "Baskin-Robbins"
    }

    // ── Baskin-Robbins-specific public methods ─────────────────────────────────

    /** @return {@code true} if "Why Baskin-Robbins?" heading is visible */
    public boolean isWhyBaskinRobbinsHeadingDisplayed() {
        return isVisibleAfterWait(whyBaskinRobbinsHeading);
    }

    /** @return {@code true} if the Entrepreneur award line is visible */
    public boolean isEntrepreneurAwardDisplayed() {
        return isVisibleAfterWait(entrepreneurAward);
    }

    /** @return {@code true} if the Franchise 500 award line is visible */
    public boolean isFranchise500AwardDisplayed() {
        return isVisibleAfterWait(franchise500Award);
    }

    /** @return {@code true} if the Top Food Franchises award line is visible */
    public boolean isTopFoodFranchiseAwardDisplayed() {
        return isVisibleAfterWait(topFoodFranchiseAward);
    }

    /** @return {@code true} if "$100,000 liquid assets" requirement is visible */
    public boolean isLiquidAssetsRequirementDisplayed() {
        return isVisibleAfterWait(liquidAssetsText);
    }

    /** @return {@code true} if "$200,000 net worth" requirement is visible */
    public boolean isNetWorthRequirementDisplayed() {
        return isVisibleAfterWait(netWorthText);
    }

    /** @return {@code true} if "Free Standing" format card is visible */
    public boolean isFreeStandingFormatDisplayed() {
        return isVisibleAfterWait(freeStandingFormat);
    }

    /** @return {@code true} if "Endcap" format card is visible */
    public boolean isEndcapFormatDisplayed() {
        return isVisibleAfterWait(endcapFormat);
    }

    /** @return {@code true} if "Inline" format card is visible (BR-specific) */
    public boolean isInlineFormatDisplayed() {
        return isVisibleAfterWait(inlineFormat);
    }

    /** @return {@code true} if "Small Format" format card is visible */
    public boolean isSmallFormatDisplayed() {
        return isVisibleAfterWait(smallFormat);
    }

    /** @return {@code true} if "Anything is possible with Baskin-Robbins" section is visible */
    public boolean isAnythingIsPossibleSectionDisplayed() {
        return isVisibleAfterWait(anythingIsPossibleSection);
    }

    /**
     * Returns the href of the GET STARTED link (should contain brand query param).
     *
     * @return href attribute value, e.g. "…/franchise-with-us?brand=Baskin-Robbins"
     */
    public String getGetStartedLinkHref() {
        return baskinGetStartedLink.getAttribute("href");
    }

    /** @return {@code true} if the "7,800" shop-count factoid is visible */
    public boolean isRestaurantCountDisplayed() {
        return isVisibleAfterWait(restaurantCountText);
    }
}
