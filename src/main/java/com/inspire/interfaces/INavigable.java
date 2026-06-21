package com.inspire.interfaces;

/**
 * Contract for pages that expose top-level navigation functionality.
 *
 * <p>Interface Segregation Principle: navigation methods are isolated in their
 * own interface so that page objects which do not have a navigation bar do not
 * need to implement them.
 */
public interface INavigable {

    /** @return {@code true} if the primary navigation bar is visible */
    boolean isNavigationBarDisplayed();

    /**
     * Opens the "Our Brands" dropdown in the navigation bar.
     *
     * @return {@code this} for fluent chaining
     */
    INavigable openOurBrandsMenu();

    /**
     * Returns whether the specified brand name is listed in the
     * "Our Brands" dropdown menu.
     *
     * @param brandDisplayName the visible brand label (e.g. "Arby's")
     * @return {@code true} if the item is present and visible
     */
    boolean isBrandInDropdown(String brandDisplayName);

    /**
     * Clicks a brand link inside the "Our Brands" dropdown and returns
     * the resulting URL of the page navigated to.
     *
     * @param brandDisplayName the visible brand label to click
     * @return the URL after navigation
     */
    String clickBrandInDropdown(String brandDisplayName);

    /**
     * Clicks the top-level "Get Started" navigation button and returns
     * the resulting URL.
     *
     * @return the URL after navigation
     */
    String clickNavGetStarted();
}
