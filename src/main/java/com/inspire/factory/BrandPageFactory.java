package com.inspire.factory;

import com.inspire.enums.Brand;
import com.inspire.pages.brands.AbstractBrandPage;
import com.inspire.pages.brands.ArbysPage;
import com.inspire.pages.brands.BaskinRobbinsPage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;

/**
 * Factory class responsible for creating brand-specific page objects.
 *
 * <p>Open/Closed Principle: to support a new brand, add an enum constant in
 * {@link Brand}, create its page class (extending {@link AbstractBrandPage}),
 * and add one {@code case} here. No other class needs to change.
 *
 * <p>Dependency Inversion Principle: callers depend on the
 * {@link AbstractBrandPage} abstraction, not on concrete page types like
 * {@link ArbysPage}.
 */
public final class BrandPageFactory {

    private static final Logger LOG = LogManager.getLogger(BrandPageFactory.class);

    private BrandPageFactory() {}

    /**
     * Creates and returns the appropriate page object for the given {@link Brand}.
     *
     * @param brand  the brand to create a page object for
     * @param driver an active {@link WebDriver} instance
     * @return a concrete {@link AbstractBrandPage} subtype for the brand
     * @throws UnsupportedOperationException if the brand has no page class yet
     */
    public static AbstractBrandPage create(Brand brand, WebDriver driver) {
        LOG.info("Creating page object for brand: {}", brand.getDisplayName());
        switch (brand) {
            case ARBYS:
                return new ArbysPage(driver);

            case BASKIN_ROBBINS:
                return new BaskinRobbinsPage(driver);

            /*
             * Future brands – uncomment and add the corresponding page class:
             *
             * case BASKIN_ROBBINS:
             *     return new BaskinRobbinsPage(driver);
             * case BUFFALO_WILD_WINGS:
             *     return new BuffaloWildWingsPage(driver);
             * case BWW_GO:
             *     return new BwwGoPage(driver);
             * case DUNKIN:
             *     return new DunkinPage(driver);
             * case JIMMY_JOHNS:
             *     return new JimmyJohnsPage(driver);
             * case SONIC:
             *     return new SonicPage(driver);
             */

            default:
                throw new UnsupportedOperationException(
                        "No page class implemented for brand: " + brand.getDisplayName()
                        + ". Create a page class and add a case to BrandPageFactory.");
        }
    }

    /**
     * Convenience overload that resolves the brand from a string key, useful
     * when reading the {@code active.brand} system property.
     *
     * @param brandKey  lower-case properties key, e.g. "arbys"
     * @param driver    an active {@link WebDriver} instance
     * @return page object for the resolved brand
     */
    public static AbstractBrandPage create(String brandKey, WebDriver driver) {
        Brand brand = Brand.fromKey(brandKey);
        return create(brand, driver);
    }
}
