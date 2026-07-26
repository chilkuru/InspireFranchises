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

    // "Why Baskin-Robbins?" section heading
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')])[1]")
    private WebElement whyBaskinRobbinsHeading;

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

    public boolean isWhyBaskinRobbinsHeadingDisplayed() {
        return isVisibleAfterWait(whyBaskinRobbinsHeading);
    }

    public boolean isEntrepreneurAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.entrepreneur", "Entrepreneur Best of the Best");
        return isVisibleAfterWait(findByContainsText(award));
    }

    public boolean isFranchise500AwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.franchise500", "Franchise 500");
        return isVisibleAfterWait(findByContainsText(award));
    }

    public boolean isTopFoodAwardDisplayed() {
        String award = ConfigReader.getInstance().get("brand.award.topfood", "Top Food");
        return isVisibleAfterWait(findByContainsText(award));
    }

    public boolean isLiquidAssetsRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.liquid.assets", "100,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    public boolean isNetWorthRequirementDisplayed() {
        String amount = ConfigReader.getInstance().get("brand.net.worth", "200,000");
        return isVisibleAfterWait(findByContainsText(amount));
    }

    public boolean isFreeStandingFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.freestanding", "Free Standing");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    public boolean isEndcapFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.endcap", "Endcap");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    public boolean isInlineFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.inline", "Inline");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    public boolean isSmallFormatDisplayed() {
        String label = ConfigReader.getInstance().get("brand.format.smallformat", "Small Format");
        return isVisibleAfterWait(findByHeadingContainsText(label));
    }

    public boolean isAnythingIsPossibleSectionDisplayed() {
        String val = ConfigReader.getInstance().get(
                "brand.section.anything.possible", "Anything is possible with Baskin-Robbins");
        // Split at hyphen-containing brand name — use "Anything is possible with Baskin"
        // to avoid any rendering variation in "Baskin-Robbins"
        String safeText = val.contains("Baskin") ? "Anything is possible with Baskin" : val;
        return isVisibleAfterWait(findByContainsText(safeText));
    }

    public boolean isShopCountDisplayed() {
        String count = ConfigReader.getInstance().get("brand.shop.count", "7,800");
        return isVisibleAfterWait(findByContainsText(count));
    }
}
