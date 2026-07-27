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
 * locators and behaviour. This class adds only Baskin-Robbins-specific
 * locators and methods.
 *
 * <p>
 * NOTE: Baskin-Robbins has 4 restaurant formats (Free Standing, Endcap,
 * Inline, Small Format) — one more than Arby's.
 */
public class BaskinRobbinsPage extends AbstractBrandPage {

    // ── Baskin-Robbins-specific locators ───────────────────────────────────────

    // "Why Baskin-Robbins?" heading — split on hyphen-containing name is safe;
    // no apostrophe in "Baskin-Robbins" so no XPath escaping issue.
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')])[1]")
    private WebElement whyBaskinHeading;

    // GET STARTED link – must include brand query param
    @FindBy(xpath = "//a[contains(@href, 'franchise-with-us') and contains(@href, 'Baskin')]")
    private WebElement brGetStartedLink;

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

    /**
     * @return {@code true} if "Why Baskin-Robbins?" heading is visible
     */
    public boolean isWhyBaskinHeadingDisplayed() {
        return isVisibleAfterWait(whyBaskinHeading);
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
     * @return {@code true} if the liquid assets requirement is visible
     */
    public boolean isLiquidAssetsRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.liquid.assets", "100,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /**
     * @return {@code true} if the net worth requirement is visible
     */
    public boolean isNetWorthRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.net.worth", "200,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /**
     * @return {@code true} if the "Free Standing" format card heading is visible
     */
    public boolean isFreeStandingFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.freestanding", "Free Standing");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Endcap" format card heading is visible
     */
    public boolean isEndcapFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.endcap", "Endcap");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Inline" format card heading is visible
     */
    public boolean isInlineFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.inline", "Inline");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Small Format" format card heading is visible
     */
    public boolean isSmallFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.smallformat", "Small Format");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    /**
     * @return {@code true} if the "Anything is possible with Baskin-Robbins" section is visible
     */
    public boolean isAnythingIsPossibleSectionDisplayed() {
        String val = ConfigReader.getInstance().get(
                "brand.section.anything.possible", "Anything is possible");
        // No apostrophe in "Baskin-Robbins" — split is a no-op but kept for consistency
        String safeText = val.split("['\u2019]")[0].trim();
        return isVisibleAfterWait(findByContainsText(safeText));
    }

    /**
     * Returns the href of the GET STARTED link (should contain brand query param).
     *
     * @return href attribute value, e.g. "…/franchise-with-us?brand=Baskin-Robbins"
     */
    public String getGetStartedLinkHref() {
        return brGetStartedLink.getAttribute("href");
    }

    /**
     * @return {@code true} if the restaurant-count factoid (7,800 shops) is visible
     */
    public boolean isRestaurantCountDisplayed() {
        String count = ConfigReader.getInstance().get("brand.restaurant.count", "7,800");
        return isVisibleAfterWait(findByContainsText(count));
    }
}
