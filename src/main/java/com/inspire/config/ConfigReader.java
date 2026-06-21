package com.inspire.config;

import com.inspire.constants.AppConstants;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Singleton configuration reader that merges two property sources:
 * <ol>
 * <li>{@code config.properties} – global settings (browser, base URL, timeouts)
 * <li>{@code brands/<brand>.properties} – brand-specific overrides (page URL,
 * expected text)
 * </ol>
 *
 * <p>
 * The active brand is resolved from (highest priority first):
 * <ol>
 * <li>JVM system property {@code active.brand} (set by Maven Surefire / -D
 * flag)
 * <li>Property {@code active.brand} in {@code config.properties}
 * <li>Fallback to {@code "arbys"}
 * </ol>
 *
 * <p>
 * Single Responsibility: this class is solely responsible for reading and
 * exposing configuration. It has no knowledge of WebDriver or test logic.
 */
public final class ConfigReader {

    private static final Logger LOG = LogManager.getLogger(ConfigReader.class);

    // ── eager singleton ────────────────────────────────────────────────────────

    private static final ConfigReader INSTANCE = new ConfigReader();

    private final Properties merged = new Properties();
    private final String activeBrand;

    // ── constructor ────────────────────────────────────────────────────────────

    private ConfigReader() {
        // 1. load global config
        Properties global = loadFromClasspath("config.properties");
        merged.putAll(global);

        // 2. resolve active brand
        String sysBrand = System.getProperty("active.brand");
        if (sysBrand != null && !sysBrand.isBlank()) {
            activeBrand = sysBrand.trim().toLowerCase();
        } else {
            activeBrand = merged.getProperty("active.brand", "arbys").trim().toLowerCase();
        }
        LOG.info("ConfigReader initialised with active brand: {}", activeBrand);

        // 3. overlay brand-specific properties
        if (!"all".equalsIgnoreCase(activeBrand)) {
            String brandFile = "brands/" + activeBrand + ".properties";
            Properties brandProps = loadFromClasspath(brandFile);
            merged.putAll(brandProps);
            LOG.info("Brand properties loaded from: {}", brandFile);
        }
    }

    // ── public API ─────────────────────────────────────────────────────────────

    /** Returns the singleton instance. */
    public static ConfigReader getInstance() {
        return INSTANCE;
    }

    /**
     * Returns a string property value.
     *
     * @param key property key
     * @return value or {@code null} if absent
     */
    public String get(String key) {
        return merged.getProperty(key);
    }

    /**
     * Returns a string property value with a default fallback.
     *
     * @param key          property key
     * @param defaultValue value to return when the key is missing
     * @return resolved value
     */
    public String get(String key, String defaultValue) {
        return merged.getProperty(key, defaultValue);
    }

    /**
     * Returns an integer property value with a default fallback.
     *
     * @param key          property key
     * @param defaultValue value to return when the key is missing or unparseable
     * @return resolved int value
     */
    public int getInt(String key, int defaultValue) {
        String val = merged.getProperty(key);
        if (val == null || val.isBlank())
            return defaultValue;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException ex) {
            LOG.warn("Property '{}' value '{}' is not a valid integer; using default {}", key, val, defaultValue);
            return defaultValue;
        }
    }

    /** @return the active brand key (lower-case), e.g. "arbys" */
    public String getActiveBrand() {
        return activeBrand;
    }

    /**
     * Convenience: returns the base URL, preferring the property value over the
     * hard-coded constant so QA can override it for different environments.
     */
    public String getBaseUrl() {
        return get("base.url", AppConstants.BASE_URL);
    }

    /**
     * Returns the configured browser name (default: chrome).
     * JVM system property {@code -Dbrowser=firefox} takes highest priority.
     */
    public String getBrowser() {
        String sysProp = System.getProperty("browser");
        if (sysProp != null && !sysProp.isBlank())
            return sysProp.trim().toLowerCase();
        return get("browser", "chrome").toLowerCase();
    }

    /**
     * Returns whether tests should run headless (default: false).
     * JVM system property {@code -Dheadless=true} takes highest priority.
     */
    public boolean isHeadless() {
        String sysProp = System.getProperty("headless");
        if (sysProp != null && !sysProp.isBlank())
            return Boolean.parseBoolean(sysProp.trim());
        return Boolean.parseBoolean(get("headless", "false"));
    }

    /** Returns explicit-wait timeout in seconds. */
    public int getExplicitWaitSec() {
        return getInt("explicit.wait.sec", AppConstants.DEFAULT_EXPLICIT_WAIT_SEC);
    }

    // ── private helpers ────────────────────────────────────────────────────────

    private Properties loadFromClasspath(String resourcePath) {
        Properties props = new Properties();
        try (InputStream is = Thread.currentThread()
                .getContextClassLoader()
                .getResourceAsStream(resourcePath)) {

            if (is == null) {
                LOG.warn("Resource not found on classpath: {} – skipping", resourcePath);
                return props;
            }
            props.load(is);
        } catch (IOException e) {
            LOG.error("Failed to load properties from {}: {}", resourcePath, e.getMessage());
        }
        return props;
    }
}
