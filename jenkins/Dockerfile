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

# Fix Git "dubious ownership" error for the mounted local workspace.
# The volume /workspace/InspireFranchises is owned by the Windows host user,
# but Jenkins runs as UID 1000. Git 2.35+ refuses to access mismatched-owner
# directories. Registering it as a safe.directory at system level (/etc/gitconfig)
# makes this permanent across container restarts and rebuilds.
RUN git config --system --add safe.directory /workspace/InspireFranchises

# Switch back to the unprivileged jenkins user
USER jenkins

# Pre-install required plugins at image build time.
# This is the correct Jenkins-in-Docker pattern: bake plugins into the image
# so they are available on first start without hitting the update center at runtime.
#
# Plugins installed:
#   workflow-aggregator  — full Pipeline suite (Declarative + Scripted)
#   git                  — Git SCM support for Pipeline from SCM
#   junit                — JUnit XML test result publishing
#   pipeline-stage-view  — Pipeline stage visualization in the UI
RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    junit \
    pipeline-stage-view

# Disable the Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
