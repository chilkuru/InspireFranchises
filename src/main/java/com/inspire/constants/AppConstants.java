package com.inspire.constants;

/**
 * Application-wide string constants — URLs, expected text tokens, section
 * headings and other values that are <em>not</em> brand-specific.
 *
 * <p>Keeping literals here rather than scattered across page/test classes makes
 * maintenance trivial: one place to update if the site changes wording.
 */
public final class AppConstants {

    private AppConstants() {
        // utility class – no instantiation
    }

    // ── Base URL ───────────────────────────────────────────────────────────────

    public static final String BASE_URL = "https://www.franchising.inspirebrands.com";

    // ── Navigation ─────────────────────────────────────────────────────────────

    public static final String NAV_LINK_HOME            = "Home";
    public static final String NAV_LINK_OUR_BRANDS      = "Our Brands";
    public static final String NAV_LINK_NON_TRADITIONAL = "Non-Traditional";
    public static final String NAV_BTN_GET_STARTED      = "Get Started";

    // ── Home page ──────────────────────────────────────────────────────────────

    public static final String HOME_HERO_HEADING        = "Anything is Possible";
    public static final String HOME_HERO_SUBHEADING     = "Any brand. Any format. Any space.";
    public static final String HOME_BRANDS_SECTION_HDR  = "Grow with Inspire's Iconic Brands";
    public static final String HOME_FORMATS_SECTION_HDR = "Any Format";
    public static final String HOME_SPACES_SECTION_HDR  = "Any Space";
    public static final String HOME_GET_STARTED_CTA     = "GET STARTED";
    public static final String HOME_HOW_TO_FRANCHISEE   = "How do I become a franchisee?";

    // ── Common brand page ──────────────────────────────────────────────────────

    /** Prefix used in brand page hero headings, e.g. "Franchise with Arby's" */
    public static final String BRAND_HERO_HEADING_PREFIX = "Franchise with";

    public static final String BRAND_HELP_SECTION_HDR   = "Here's how we help";
    public static final String BRAND_SUPPORT_TRAINING   = "Training";
    public static final String BRAND_SUPPORT_MARKETING  = "Marketing";
    public static final String BRAND_SUPPORT_TECH       = "Technology";
    public static final String BRAND_WHAT_NEXT_HDR      = "What's next?";
    public static final String BRAND_QUALIFICATION_HDR  = "qualify";

    // Franchise process steps
    public static final String STEP_1_APPLY   = "Apply";
    public static final String STEP_2_DISCUSS = "Discuss";
    public static final String STEP_3_REVIEW  = "Review";
    public static final String STEP_4_INTERVIEW = "Interview";
    public static final String STEP_5_SIGN    = "Sign";

    // ── Footer ─────────────────────────────────────────────────────────────────

    public static final String FOOTER_COMPANY_NAME = "INSPIRE BRANDS FRANCHISING";
    public static final String FOOTER_PRIVACY_TEXT  = "Privacy";
    public static final String FOOTER_LINKEDIN_URL  = "linkedin.com/company";

    // ── Form / CTA ─────────────────────────────────────────────────────────────

    public static final String FRANCHISE_FORM_PATH = "/franchise-with-us";

    // ── Timeouts ───────────────────────────────────────────────────────────────

    public static final int DEFAULT_EXPLICIT_WAIT_SEC = 15;
    public static final int PAGE_LOAD_TIMEOUT_SEC     = 30;
    public static final int IMPLICIT_WAIT_SEC         = 0;   // always 0; use explicit waits
}
