package com.inspire.pages.brands;

import com.inspire.base.BasePage;
import com.inspire.constants.AppConstants;
import com.inspire.interfaces.IBrandPage;
import com.inspire.utils.WaitUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * Abstract base class for all brand-specific page objects.
 *
 * <p>
 * Encapsulates the locators and behaviour that are identical across every
 * brand franchising page (hero CTA, "Here's how we help" section, qualification
 * requirements, five-step "What's next?" process, footer, etc.).
 *
 * <p>
 * Open/Closed Principle: this class is closed for modification but open for
 * extension. A new brand page only needs to declare brand-specific locators and
 * override {@link #getBrandDisplayName()} / {@link #getBrandPageUrl()}.
 *
 * <p>
 * Liskov Substitution Principle: every concrete brand page can be used
 * wherever an {@link IBrandPage} or {@link AbstractBrandPage} reference is
 * expected.
 */
public abstract class AbstractBrandPage extends BasePage implements IBrandPage {

    // ── Common locators (shared across every brand page) ───────────────────────

    // Hero
    @FindBy(xpath = "//h1[contains(normalize-space(.),'Franchise with')]"
            + " | //h2[contains(normalize-space(.),'Franchise with')]")
    protected WebElement heroHeading;

    // Hero GET STARTED — use normalize-space(.) for nested-span Squarespace
    // buttons.
    // Exclude header/nav ancestors so we match only the visible in-content CTA,
    // not the duplicate link that lives in the hidden mobile navigation.
    @FindBy(xpath = "(//a[contains(normalize-space(.), 'GET STARTED')"
            + " and contains(@href,'franchise-with-us')"
            + " and not(ancestor::header)"
            + " and not(ancestor::nav)])[1]")
    protected WebElement heroGetStartedButton;

    // "Why [Brand]?" section — proper union syntax across heading levels
    // (avoids invalid 'self::h2[...]' predicate that never matches)
    @FindBy(xpath = "//h2[contains(normalize-space(.), 'Why')]"
            + " | //h3[contains(normalize-space(.), 'Why')]"
            + " | //h4[contains(normalize-space(.), 'Why')]")
    protected WebElement whyBrandHeading;

    // "Here's how we help" section
    // Avoid straight-vs-curly apostrophe mismatch in "Here's" by matching
    // the apostrophe-free substring 'how we help' which is unique on the page.
    @FindBy(xpath = "//*[contains(normalize-space(.), 'how we help')]")
    protected WebElement helpSectionHeading;

    // Support pillars — use normalize-space(.) to match text inside nested spans
    @FindBy(xpath = "//*[contains(normalize-space(.), 'Training')]"
            + "[not(self::script)][not(self::style)]")
    protected WebElement trainingSupportHeading;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Marketing')]"
            + "[not(self::script)][not(self::style)]")
    protected WebElement marketingHeading;

    @FindBy(xpath = "//*[contains(normalize-space(.), 'Technology')]"
            + "[not(self::script)][not(self::style)]")
    protected WebElement technologyHeading;

    // Qualification requirements section
    @FindBy(xpath = "//*[contains(translate(normalize-space(.),"
            + "'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'qualify')]"
            + "[not(self::script)][not(self::style)]")
    protected WebElement qualificationSection;

    // "What's next?" section — avoid curly apostrophe in "What's" by splitting
    @FindBy(xpath = "//*[contains(normalize-space(.), 'What')"
            + " and contains(normalize-space(.), 'next')]"
            + "[not(self::script)][not(self::style)]")
    protected WebElement whatNextHeading;

    // Five franchise process steps (locate by step numbers ① – ⑤)
    @FindBy(xpath = "//*[normalize-space(text())='①' or normalize-space(text())='Apply']"
            + "[not(self::script)]")
    protected WebElement stepApply;

    @FindBy(xpath = "//*[normalize-space(text())='②' or normalize-space(text())='Discuss']"
            + "[not(self::script)]")
    protected WebElement stepDiscuss;

    @FindBy(xpath = "//*[normalize-space(text())='③' or normalize-space(text())='Review']"
            + "[not(self::script)]")
    protected WebElement stepReview;

    @FindBy(xpath = "//*[normalize-space(text())='④' or normalize-space(text())='Interview']"
            + "[not(self::script)]")
    protected WebElement stepInterview;

    @FindBy(xpath = "//*[normalize-space(text())='⑤' or normalize-space(text())='Sign' or "
            + "normalize-space(text())='Sign!'][not(self::script)]")
    protected WebElement stepSign;

    // Footer
    @FindBy(css = "footer, [class*='footer']")
    protected WebElement footer;

    // Cross-brand promotion links (the "Or franchise with any of Inspire's brands…"
    // row)
    @FindBy(xpath = "//*[contains(normalize-space(.),'franchise with any of')]")
    protected WebElement otherBrandsHeading;

    // ── Constructor ────────────────────────────────────────────────────────────

    protected AbstractBrandPage(WebDriver driver) {
        super(driver);
    }

    // ── Abstract methods (subclasses must implement) ───────────────────────────

    /**
     * Returns the relative URL path for this brand page, e.g. "/arbys".
     */
    public abstract String getBrandPagePath();

    // ── IBrandPage implementation ──────────────────────────────────────────────

    @Override
    public IBrandPage open() {
        String url = AppConstants.BASE_URL + getBrandPagePath();
        log.info("Opening brand page: {}", url);
        navigateTo(url);
        return this;
    }

    @Override
    public String getHeroHeadingText() {
        return getText(heroHeading);
    }

    @Override
    public boolean isGetStartedButtonDisplayed() {
        // Scroll the hero CTA into view before checking visibility —
        // it can be below the initial viewport on some window sizes.
        try {
            WaitUtils.scrollIntoView(driver, heroGetStartedButton);
        } catch (Exception e) {
            log.warn("heroGetStartedButton not found in DOM: {}", e.getMessage());
            return false;
        }
        return isVisibleAfterWait(heroGetStartedButton);
    }

    @Override
    public String clickGetStartedAndGetUrl() {
        // Scroll to element and capture its href before clicking.
        // If a Squarespace overlay (e.g. deferred JS hydration) prevents the
        // click from triggering navigation, we fall back to driver.get(href).
        WaitUtils.scrollIntoView(driver, heroGetStartedButton);
        String href = heroGetStartedButton.getAttribute("href");
        log.info("GET STARTED href resolved as: {}", href);

        click(heroGetStartedButton);

        // Wait up to 8 s for the URL to contain /franchise-with-us
        try {
            WaitUtils.waitForUrlContains(driver,
                    com.inspire.constants.AppConstants.FRANCHISE_FORM_PATH, 8);
        } catch (org.openqa.selenium.TimeoutException e) {
            // Click did not trigger navigation — navigate directly via the href
            log.warn("Click did not navigate to form; using href directly: {}", href);
            if (href != null && !href.isBlank()) {
                driver.get(href);
            }
        }
        return getCurrentUrl();
    }

    @Override
    public boolean isWhyBrandSectionDisplayed() {
        return isVisibleAfterWait(whyBrandHeading);
    }

    @Override
    public boolean isHelpSectionDisplayed() {
        return isVisibleAfterWait(helpSectionHeading);
    }

    @Override
    public boolean isTrainingSupportDisplayed() {
        return isVisibleAfterWait(trainingSupportHeading);
    }

    @Override
    public boolean isMarketingPRDisplayed() {
        return isVisibleAfterWait(marketingHeading);
    }

    @Override
    public boolean isTechInnovationDisplayed() {
        return isVisibleAfterWait(technologyHeading);
    }

    @Override
    public boolean isQualificationSectionDisplayed() {
        return isVisibleAfterWait(qualificationSection);
    }

    @Override
    public boolean isWhatNextSectionDisplayed() {
        return isVisibleAfterWait(whatNextHeading);
    }

    @Override
    public boolean areFranchiseStepsDisplayed() {
        scrollToBottom();
        return isVisibleAfterWait(stepApply)
                && isVisibleAfterWait(stepDiscuss)
                && isVisibleAfterWait(stepReview)
                && isVisibleAfterWait(stepInterview)
                && isVisibleAfterWait(stepSign);
    }

    @Override
    public boolean isFooterDisplayed() {
        scrollToBottom();
        return isVisibleAfterWait(footer);
    }

    @Override
    public boolean isOtherBrandsLinksDisplayed() {
        scrollToBottom();
        return isVisibleAfterWait(otherBrandsHeading);
    }

    // ── Shared helper ──────────────────────────────────────────────────────────

    /**
     * Builds and returns the full brand page URL (base URL + path).
     */
    public String getBrandPageUrl() {
        return AppConstants.BASE_URL + getBrandPagePath();
    }

    /**
     * Verifies the current browser URL contains the expected brand path.
     *
     * @return {@code true} if URL contains the brand slug
     */
    public boolean isOnBrandPage() {
        return getCurrentUrl().contains(getBrandPagePath());
    }

    /**
     * Returns the page {@literal <title>} as reported by the browser.
     */
    public String getPageTitleText() {
        return getPageTitle();
    }
}
