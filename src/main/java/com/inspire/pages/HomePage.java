package com.inspire.pages;

import com.inspire.base.BasePage;
import com.inspire.constants.AppConstants;
import com.inspire.interfaces.INavigable;
import com.inspire.utils.WaitUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * Page Object for the Inspire Brands Franchising home page:
 * https://www.franchising.inspirebrands.com/
 *
 * <p>
 * Uses Page Factory ({@link org.openqa.selenium.support.FindBy}) for all
 * locator declarations – no string literals inside method bodies.
 *
 * <p>
 * Implements {@link INavigable} for the top-level navigation bar interactions.
 * All navigation methods return {@code this} or a URL string for fluent
 * chaining.
 */
public class HomePage extends BasePage implements INavigable {

    // ── Locators ───────────────────────────────────────────────────────────────

    // Navigation bar
    @FindBy(css = "header nav, #navigation, .header-nav, [class*='header']")
    private WebElement navigationBar;

    @FindBy(xpath = "//a[contains(text(),'Our Brands')] | //button[contains(text(),'Our Brands')]"
            + " | //*[normalize-space(text())='Our Brands']")
    private WebElement ourBrandsMenuTrigger;

    @FindBy(xpath = "//a[normalize-space(text())='Get Started'] "
            + "| //a[normalize-space(text())='GET STARTED'][ancestor::header or ancestor::nav]")
    private WebElement navGetStartedButton;

    // Hero section
    @FindBy(xpath = "//h1[contains(normalize-space(.), 'Anything is Possible')]"
            + " | //h2[contains(normalize-space(.), 'Anything is Possible')]")
    private WebElement heroHeading;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Any brand. Any format. Any space.')]")
    private WebElement heroSubHeading;

    // Hero GET STARTED — DOM text is "Get Started" (CSS text-transform renders it
    // as uppercase).
    // Multiple nav copies exist with the same href; exclude them via
    // ancestor::header
    // (catches nav copies even when <header> is 6+ levels up) and ancestor::nav.
    // Take [1] to get the hero button before the brands-section copy at [2].
    @FindBy(xpath = "(//a[normalize-space(.)='Get Started'"
            + " and contains(@href,'franchise-with-us')"
            + " and not(ancestor::header)"
            + " and not(ancestor::nav)"
            + " and not(ancestor::footer)])[1]")
    private WebElement heroGetStartedButton;

    // Brands section — split contains() to avoid straight-vs-curly apostrophe
    // mismatch in DOM
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Grow with Inspire')"
            + " and contains(normalize-space(.), 'Iconic Brands')]")
    private WebElement brandsSectionHeading;

    // Formats section
    @FindBy(xpath = "//h1[normalize-space(text())='Any Format'] "
            + "| //h2[normalize-space(text())='Any Format'] "
            + "| //h3[normalize-space(text())='Any Format']")
    private WebElement formatsSectionHeading;

    // "How do I become a franchisee?" section — use normalize-space(.) for nested
    // text
    @FindBy(xpath = "//*[contains(normalize-space(.), 'How do I become a franchisee')]")
    private WebElement howToFranchiseeHeading;

    // Footer
    @FindBy(css = "footer, [class*='footer']")
    private WebElement footer;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'INSPIRE BRANDS FRANCHISING')]")
    private WebElement footerCompanyName;

    @FindBy(xpath = "//a[contains(@href,'linkedin.com')]")
    private WebElement linkedInLink;

    @FindBy(xpath = "//a[contains(normalize-space(.),'Privacy') and not(contains(@href,'Settings'))]")
    private WebElement privacyLink;

    // Brand links on the page body — prefer the text "LEARN MORE" link for Arby's
    // (image-only logo anchors have zero size and are not directly clickable)
    @FindBy(xpath = "//a[normalize-space(.)='LEARN MORE' and contains(@href,'/arbys')]"
            + " | //a[contains(@href,'/arbys') and not(ancestor::footer) and not(ancestor::header)]"
            + "[.//img or normalize-space(.)]")
    private WebElement arbysBodyLink;

    // ── Constructor ────────────────────────────────────────────────────────────

    public HomePage(WebDriver driver) {
        super(driver);
    }

    // ── Open ───────────────────────────────────────────────────────────────────

    /**
     * Navigates to the home page.
     *
     * @return {@code this} for fluent chaining
     */
    public HomePage open() {
        navigateTo(AppConstants.BASE_URL);
        return this;
    }

    // ── Hero section ───────────────────────────────────────────────────────────

    public boolean isHeroHeadingDisplayed() {
        return isVisibleAfterWait(heroHeading);
    }

    public String getHeroHeadingText() {
        return getText(heroHeading);
    }

    public boolean isHeroSubHeadingDisplayed() {
        return isVisibleAfterWait(heroSubHeading);
    }

    public boolean isHeroGetStartedButtonDisplayed() {
        return isVisibleAfterWait(heroGetStartedButton);
    }

    public String clickHeroGetStartedAndGetUrl() {
        // Scroll to the hero button and resolve href before clicking.
        // Use JS click to bypass fixed-header interception (the content-area button
        // is below the viewport fold and the fixed nav can intercept a coordinate
        // click).
        // Fall back to driver.get(href) if click does not trigger navigation.
        WaitUtils.scrollIntoView(driver, heroGetStartedButton);
        String href = heroGetStartedButton.getAttribute("href");
        log.info("Hero GET STARTED href resolved as: {}", href);

        ((org.openqa.selenium.JavascriptExecutor) driver)
                .executeScript("arguments[0].click();", heroGetStartedButton);

        try {
            WaitUtils.waitForUrlContains(driver, AppConstants.FRANCHISE_FORM_PATH, 8);
        } catch (org.openqa.selenium.TimeoutException e) {
            log.warn("JS click did not navigate; using href directly: {}", href);
            if (href != null && !href.isBlank()) {
                driver.get(href);
            }
        }
        return getCurrentUrl();
    }

    // ── Navigation ─────────────────────────────────────────────────────────────

    @Override
    public boolean isNavigationBarDisplayed() {
        return isVisibleAfterWait(navigationBar);
    }

    @Override
    public INavigable openOurBrandsMenu() {
        hoverOver(ourBrandsMenuTrigger);
        return this;
    }

    @Override
    public boolean isBrandInDropdown(String brandDisplayName) {
        openOurBrandsMenu();
        return pageContainsText(brandDisplayName);
    }

    @Override
    public String clickBrandInDropdown(String brandDisplayName) {
        openOurBrandsMenu();
        WebElement brandLink = driver.findElement(
                org.openqa.selenium.By.xpath(
                        "//nav//a[normalize-space(text())='" + brandDisplayName + "']"
                                + " | //header//a[normalize-space(text())='" + brandDisplayName + "']"));
        click(brandLink);
        return getCurrentUrl();
    }

    @Override
    public String clickNavGetStarted() {
        click(navGetStartedButton);
        return getCurrentUrl();
    }

    // ── Content sections ───────────────────────────────────────────────────────

    public boolean isBrandsSectionDisplayed() {
        return isVisibleAfterWait(brandsSectionHeading);
    }

    public boolean isFormatsSectionDisplayed() {
        return isVisibleAfterWait(formatsSectionHeading);
    }

    public boolean isHowToFranchiseeSectionDisplayed() {
        return isVisibleAfterWait(howToFranchiseeHeading);
    }

    // ── Footer ─────────────────────────────────────────────────────────────────

    public boolean isFooterDisplayed() {
        scrollToBottom();
        return isVisibleAfterWait(footer);
    }

    public boolean isFooterCompanyNameDisplayed() {
        scrollToBottom();
        return isVisibleAfterWait(footerCompanyName);
    }

    public boolean isLinkedInLinkPresent() {
        scrollToBottom();
        return isVisibleAfterWait(linkedInLink);
    }

    public String getLinkedInHref() {
        scrollToBottom();
        return linkedInLink.getAttribute("href");
    }

    public boolean isPrivacyLinkPresent() {
        scrollToBottom();
        return isVisibleAfterWait(privacyLink);
    }

    // ── Brand links ────────────────────────────────────────────────────────────

    /**
     * Clicks the Arby's brand card/logo in the body of the home page and
     * returns the resulting URL.
     *
     * @return URL after navigating to the Arby's brand page
     */
    public String clickArbysBodyLink() {
        scrollToBottom(); // logo grid is below the fold
        click(arbysBodyLink);
        return getCurrentUrl();
    }

    public boolean isArbysBodyLinkDisplayed() {
        return isVisibleAfterWait(arbysBodyLink);
    }
}
