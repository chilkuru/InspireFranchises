package com.inspire.pages.brands;

import com.inspire.config.ConfigReader;
import com.inspire.enums.Brand;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * Page Object for the Baskin-Robbins Franchising page:
 * https://www.franchising.inspirebrands.com/baskin-robbins
 *
 * <p>
 * Extends {@link AbstractBrandPage} to inherit all common brand-page
 * locators and behaviour. This class adds only <em>Baskin-Robbins-specific</em>
 * locators and methods.
 *
 * <p>
 * All expected values (awards, qualification figures, format labels, section
 * text) are resolved from {@code brands/baskin-robbins.properties} via
 * {@link ConfigReader} — never hardcoded in test assertions.
 */
public class BaskinRobbinsPage extends AbstractBrandPage {

    // ── Baskin-Robbins-specific locators ───────────────────────────────────────

    // "Why Baskin-Robbins?" heading — no apostrophe so no split needed
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')])[1]")
    private WebElement whyBaskinRobbinsHeading;

    // GET STARTED link with brand query param
    @FindBy(xpath = "//a[contains(@href, 'franchise-with-us') and contains(@href, 'Baskin-Robbins')]")
    private WebElement baskinRobbinsGetStartedLink;

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

    /** @return {@code true} if the "Why Baskin-Robbins?" heading is visible */
    public boolean isWhyBaskinRobbinsHeadingDisplayed() {
        return isVisibleAfterWait(whyBaskinRobbinsHeading);
    }

    /** @return {@code true} if the Entrepreneur award line is visible */
    public boolean isEntrepreneurAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.entrepreneur", "Entrepreneur Best of the Best");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /** @return {@code true} if the Franchise 500 award line is visible */
    public boolean isFranchise500AwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.franchise500", "Franchise 500");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /** @return {@code true} if the Top Food Franchise award line is visible */
    public boolean isTopFoodFranchiseAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.topfood", "Top Food Franchise");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /** @return {@code true} if the liquid assets requirement is visible */
    public boolean isLiquidAssetsRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.liquid.assets", "100,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /** @return {@code true} if the net worth requirement is visible */
    public boolean isNetWorthRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.net.worth", "200,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /** @return {@code true} if the "Free Standing" format card is visible */
    public boolean isFreeStandingFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.freestanding", "Free Standing");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /** @return {@code true} if the "Endcap" format card is visible */
    public boolean isEndcapFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.endcap", "Endcap");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /** @return {@code true} if the "Inline" format card is visible */
    public boolean isInlineFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.inline", "Inline");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /** @return {@code true} if the "Small Format" format card is visible */
    public boolean isSmallFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.smallformat", "Small Format");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /** @return {@code true} if the "Anything is possible with Baskin-Robbins" section is visible */
    public boolean isAnythingIsPossibleSectionDisplayed() {
        String val = ConfigReader.getInstance().get(
                "brand.section.anything.possible", "Anything is possible with Baskin-Robbins");
        // No apostrophe in "Baskin-Robbins" — use the value directly
        return isVisibleAfterWait(findByContainsText(val));
    }

    /** @return {@code true} if the shop-count factoid (7,800) is visible */
    public boolean isRestaurantCountDisplayed() {
        String count = ConfigReader.getInstance().get("brand.restaurant.count", "7,800");
        return isVisibleAfterWait(findByContainsText(count));
    }

    /** @return href attribute of the GET STARTED link */
    public String getGetStartedLinkHref() {
        return baskinRobbinsGetStartedLink.getAttribute("href");
    }
}
