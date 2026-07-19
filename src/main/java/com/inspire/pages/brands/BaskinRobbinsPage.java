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
 * Extends {@link AbstractBrandPage} to inherit all common brand-page
 * locators and behaviour. This class adds only Baskin-Robbins-specific
 * locators and methods.
 *
 * <p>
 * Key page facts (from live site):
 * <ul>
 *   <li>Liquid assets requirement: $100,000</li>
 *   <li>Net worth requirement: $200,000</li>
 *   <li>Formats: Free Standing, Endcap, Inline, Small Format (4 total)</li>
 *   <li>Shop count factoid: 7,800 retail shops in 36 global markets</li>
 * </ul>
 */
public class BaskinRobbinsPage extends AbstractBrandPage {

    // ── "Why Baskin-Robbins?" heading ──────────────────────────────────────────
    // "Baskin-Robbins" contains a hyphen — no apostrophe issue, direct match safe
    @FindBy(xpath = "(//h2[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')]"
            + " | //h3[contains(normalize-space(.), 'Why') and contains(normalize-space(.), 'Baskin')])[1]")
    private WebElement whyBaskinRobbinsHeading;

    // ── Awards ─────────────────────────────────────────────────────────────────
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Entrepreneur')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement entrepreneurAward;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Top Food')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement topFoodFranchiseAward;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Franchise 500')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement franchise500Award;

    // ── Financial qualification requirements ──────────────────────────────────
    @FindBy(xpath = "//*[contains(normalize-space(.), '100,000')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement liquidAssetsText;

    @FindBy(xpath = "//*[contains(normalize-space(.), '200,000')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement netWorthText;

    // ── Restaurant formats (4 total — Inline is unique to Baskin-Robbins) ─────
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

    // ── "Anything is possible with Baskin-Robbins" section ────────────────────
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Anything is possible')"
            + " and contains(normalize-space(.), 'Baskin')]"
            + "[not(self::script)]")
    private WebElement anythingIsPossibleSection;

    // ── "Here's how we help" section ──────────────────────────────────────────
    // "Here's" uses curly apostrophe U+2019 on Squarespace — split into two contains()
    @FindBy(xpath = "//*[contains(normalize-space(.), 'how we help')"
            + " and contains(normalize-space(.), 'Here')]"
            + "[not(self::script)]")
    private WebElement howWeHelpSection;

    // ── 7,800 shop count factoid ───────────────────────────────────────────────
    @FindBy(xpath = "//*[contains(normalize-space(.), '7,800')]"
            + "[not(self::script)][not(self::style)]")
    private WebElement shopCountText;

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
        return isVisibleAfterWait(entrepreneurAward);
    }

    public boolean isTopFoodFranchiseAwardDisplayed() {
        return isVisibleAfterWait(topFoodFranchiseAward);
    }

    public boolean isFranchise500AwardDisplayed() {
        return isVisibleAfterWait(franchise500Award);
    }

    public boolean isLiquidAssetsRequirementDisplayed() {
        return isVisibleAfterWait(liquidAssetsText);
    }

    public boolean isNetWorthRequirementDisplayed() {
        return isVisibleAfterWait(netWorthText);
    }

    public boolean isFreeStandingFormatDisplayed() {
        return isVisibleAfterWait(freeStandingFormat);
    }

    public boolean isEndcapFormatDisplayed() {
        return isVisibleAfterWait(endcapFormat);
    }

    public boolean isInlineFormatDisplayed() {
        return isVisibleAfterWait(inlineFormat);
    }

    public boolean isSmallFormatDisplayed() {
        return isVisibleAfterWait(smallFormat);
    }

    public boolean isAnythingIsPossibleSectionDisplayed() {
        return isVisibleAfterWait(anythingIsPossibleSection);
    }

    public boolean isHowWeHelpSectionDisplayed() {
        return isVisibleAfterWait(howWeHelpSection);
    }

    public boolean isShopCountDisplayed() {
        return isVisibleAfterWait(shopCountText);
    }
}
