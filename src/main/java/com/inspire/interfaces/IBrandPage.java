package com.inspire.interfaces;

/**
 * Contract for any page object that represents a brand-specific franchising
 * page on the Inspire Brands website.
 *
 * <p>Interface Segregation Principle: this interface captures <em>only</em> the
 * behaviours that are common across every brand page. Brand-specific behaviour
 * is added in the concrete page class, not here.
 *
 * <p>Liskov Substitution Principle: every concrete brand page (e.g.
 * {@code ArbysPage}) that implements this interface can be used wherever an
 * {@code IBrandPage} reference is expected, ensuring polymorphic test execution.
 */
public interface IBrandPage {

    /**
     * Navigates the browser to the brand's franchising page URL.
     *
     * @return {@code this} for fluent chaining
     */
    IBrandPage open();

    /** @return the hero heading text (e.g. "Franchise with Arby's") */
    String getHeroHeadingText();

    /** @return {@code true} if the hero "GET STARTED" button is visible */
    boolean isGetStartedButtonDisplayed();

    /**
     * Clicks the primary "GET STARTED" call-to-action button in the hero
     * section and returns the resulting URL.
     *
     * @return the URL of the page navigated to after clicking
     */
    String clickGetStartedAndGetUrl();

    /** @return {@code true} if the "Why [Brand]?" section is visible */
    boolean isWhyBrandSectionDisplayed();

    /** @return {@code true} if the "Here's how we help" section is visible */
    boolean isHelpSectionDisplayed();

    /** @return {@code true} if the Training & Support subsection is visible */
    boolean isTrainingSupportDisplayed();

    /** @return {@code true} if the Marketing & PR subsection is visible */
    boolean isMarketingPRDisplayed();

    /** @return {@code true} if the Technology & Innovation subsection is visible */
    boolean isTechInnovationDisplayed();

    /** @return {@code true} if the qualification requirements section is visible */
    boolean isQualificationSectionDisplayed();

    /** @return {@code true} if the "What's next?" step-by-step section is visible */
    boolean isWhatNextSectionDisplayed();

    /** @return {@code true} if all five franchise process steps are visible */
    boolean areFranchiseStepsDisplayed();

    /** @return {@code true} if the footer element is visible */
    boolean isFooterDisplayed();

    /** @return {@code true} if the cross-brand promotion links section is visible */
    boolean isOtherBrandsLinksDisplayed();

    /**
     * Returns the brand display name this page object represents.
     *
     * @return e.g. "Arby's"
     */
    String getBrandDisplayName();
}
