# =============================================================================
# Jenkins agent image: Jenkins LTS + JDK 21 + Google Chrome
#
# Base image already ships with JDK 21 (required by the framework).
# Google Chrome is installed for headless Selenium test execution.
# --no-sandbox and --disable-dev-shm-usage are always set in DriverManager,
# so Chrome runs safely inside Docker without any extra flags.
# =============================================================================
FROM jenkins/jenkins:lts-jdk21

USER root

# Install prerequisites + Google Chrome stable
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        gnupg \
        curl \
        unzip \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
        | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] \
        http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Verify Chrome installation
RUN google-chrome --version

# Switch back to the unprivileged jenkins user
USER jenkins

# Disable the Jenkins setup wizard (admin user is created via environment vars)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
