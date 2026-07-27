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
 */
public class BaskinRobbinsPage extends AbstractBrandPage {

    // ── Baskin-Robbins-specific locators ───────────────────────────────────────

    // "Why Baskin-Robbins?" heading — split on hyphen to be safe
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')])[1]")
    private WebElement whyBaskinHeading;

    // GET STARTED link with brand-specific href param
    @FindBy(xpath = "//a[contains(@href, 'franchise-with-us') and contains(@href, 'Baskin')"
            + " and not(ancestor::header) and not(ancestor::nav)]")
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

    /** @return {@code true} if "Why Baskin-Robbins?" heading is visible */
    public boolean isWhyBaskinHeadingDisplayed() {
        return isVisibleAfterWait(whyBaskinHeading);
    }

    /** @return {@code true} if the Entrepreneur award line is visible */
    public boolean isEntrepreneurAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.entrepreneur", "Entrepreneur");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /** @return {@code true} if the Franchise 500 award line is visible */
    public boolean isFranchise500AwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.franchise500", "Franchise 500");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /** @return {@code true} if the Top Food Franchises award line is visible */
    public boolean isTopFoodFranchiseAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.topfood", "Top Food");
        return isVisibleAfterWait(findByContainsText(award));
    }

    /** @return {@code true} if the $100,000 liquid assets requirement is visible */
    public boolean isLiquidAssetsRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.liquid.assets", "100,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /** @return {@code true} if the $200,000 net worth requirement is visible */
    public boolean isNetWorthRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.net.worth", "200,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    /** @return {@code true} if "Free Standing" format label is visible */
    public boolean isFreeStandingFormatDisplayed() {
        String fmt = ConfigReader.getInstance().get("brand.format.freestanding", "Free Standing");
        return isVisibleAfterWait(findByContainsText(fmt));
    }

    /** @return {@code true} if "Endcap" format label is visible */
    public boolean isEndcapFormatDisplayed() {
        String fmt = ConfigReader.getInstance().get("brand.format.endcap", "Endcap");
        return isVisibleAfterWait(findByContainsText(fmt));
    }

    /** @return {@code true} if "Inline" format label is visible */
    public boolean isInlineFormatDisplayed() {
        String fmt = ConfigReader.getInstance().get("brand.format.inline", "Inline");
        return isVisibleAfterWait(findByContainsText(fmt));
    }

    /** @return {@code true} if "Small Format" label is visible */
    public boolean isSmallFormatDisplayed() {
        String fmt = ConfigReader.getInstance().get("brand.format.smallformat", "Small Format");
        return isVisibleAfterWait(findByContainsText(fmt));
    }

    /** @return {@code true} if "Anything is possible with Baskin-Robbins" section is visible */
    public boolean isAnythingIsPossibleSectionDisplayed() {
        String text = ConfigReader.getInstance().get(
                "brand.section.anything.possible", "Anything is possible with Baskin");
        return isVisibleAfterWait(findByContainsText(text));
    }

    /** @return {@code true} if the 7,800 restaurant count factoid is visible */
    public boolean isRestaurantCountDisplayed() {
        String count = ConfigReader.getInstance().get("brand.restaurant.count", "7,800");
        return isVisibleAfterWait(findByContainsText(count));
    }

    /** @return the href of the brand-specific GET STARTED link */
    public String getGetStartedLinkHref() {
        try {
            return brGetStartedLink.getAttribute("href");
        } catch (Exception e) {
            return "";
        }
    }
}
