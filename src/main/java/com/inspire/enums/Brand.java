package com.inspire.enums;

/**
 * Enum representing every brand currently offered on the Inspire Brands
 * Franchising website.
 *
 * <p>Open/Closed Principle: To add a new brand, simply add a new enum constant
 * here and supply the corresponding properties file + page class. No existing
 * code needs to change.
 *
 * <p>Each constant carries:
 * <ul>
 *   <li>{@code displayName}  – human-readable label used in reports / assertions
 *   <li>{@code urlSlug}      – the URL path segment (e.g. "arbys" → /arbys)
 *   <li>{@code propertiesKey} – the key used to locate the brand properties file
 *                               under src/test/resources/brands/
 * </ul>
 */
public enum Brand {

    ARBYS("Arby's", "arbys", "arbys"),
    BASKIN_ROBBINS("Baskin-Robbins", "baskin-robbins", "baskin-robbins"),
    BUFFALO_WILD_WINGS("Buffalo Wild Wings", "buffalo-wild-wings", "buffalo-wild-wings"),
    BWW_GO("BWW GO", "bww-go", "bww-go"),
    DUNKIN("Dunkin'", "dunkin", "dunkin"),
    JIMMY_JOHNS("Jimmy John's", "jimmy-johns", "jimmy-johns"),
    SONIC("SONIC", "sonic", "sonic");

    // ── fields ─────────────────────────────────────────────────────────────────

    private final String displayName;
    private final String urlSlug;
    private final String propertiesKey;

    // ── constructor ────────────────────────────────────────────────────────────

    Brand(String displayName, String urlSlug, String propertiesKey) {
        this.displayName    = displayName;
        this.urlSlug        = urlSlug;
        this.propertiesKey  = propertiesKey;
    }

    // ── accessors ──────────────────────────────────────────────────────────────

    public String getDisplayName()   { return displayName;    }
    public String getUrlSlug()       { return urlSlug;        }
    public String getPropertiesKey() { return propertiesKey;  }

    /**
     * Resolves a {@link Brand} from a case-insensitive properties-key string.
     * Useful when reading the {@code active.brand} system property.
     *
     * @param key the properties key (e.g. "arbys", "sonic")
     * @return matching Brand
     * @throws IllegalArgumentException if the key does not match any brand
     */
    public static Brand fromKey(String key) {
        for (Brand b : values()) {
            if (b.propertiesKey.equalsIgnoreCase(key)) {
                return b;
            }
        }
        throw new IllegalArgumentException("Unknown brand key: " + key);
    }

    @Override
    public String toString() {
        return displayName;
    }
}
