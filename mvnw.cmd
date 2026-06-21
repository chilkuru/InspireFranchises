@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
:: Maven Wrapper for Windows
:: Downloads Apache Maven on first run; no system Maven installation needed.
:: Requires: JDK 21+, internet access (first run only)
:: ============================================================================

:: ── Locate Java ──────────────────────────────────────────────────────────────
if defined JAVA_HOME (
    set "JAVA_CMD=!JAVA_HOME!\bin\java.exe"
    if not exist "!JAVA_CMD!" (
        echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
        exit /B 1
    )
) else (
    where java >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Java not found.
        echo Please install JDK 21 from https://adoptium.net and set JAVA_HOME.
        exit /B 1
    )
    set "JAVA_CMD=java"
)

:: ── Read Maven distribution URL from .mvn/wrapper/maven-wrapper.properties ───
set "PROPS=%~dp0.mvn\wrapper\maven-wrapper.properties"
if not exist "!PROPS!" (
    echo ERROR: .mvn\wrapper\maven-wrapper.properties not found.
    exit /B 1
)

:: Use PowerShell to read the property (avoids CRLF / encoding issues)
for /F "usebackq delims=" %%V in (`powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "(Get-Content '!PROPS!' | Where-Object { $_ -match '^distributionUrl=' }) -replace '^distributionUrl=','' | ForEach-Object { $_.Trim() }"`) do (
    set "DIST_URL=%%V"
)

if "!DIST_URL!"=="" (
    echo ERROR: Could not read distributionUrl from maven-wrapper.properties.
    exit /B 1
)

:: ── Derive local installation path from the file name in the URL ─────────────
for %%F in (!DIST_URL!) do set "DIST_FILE=%%~nxF"
:: Strip "-bin.zip" suffix to get the Maven dir name, e.g. apache-maven-3.9.9
set "MAVEN_DIR=!DIST_FILE:-bin.zip=!"
set "MAVEN_HOME=%USERPROFILE%\.m2\wrapper\dists\!MAVEN_DIR!"

:: ── Download and extract Maven if not already cached ─────────────────────────
if not exist "!MAVEN_HOME!\bin\mvn.cmd" (
    echo [Maven Wrapper] Maven not found locally. Downloading !MAVEN_DIR!...
    echo [Maven Wrapper] Source: !DIST_URL!
    set "TEMP_ZIP=%TEMP%\!DIST_FILE!"

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Invoke-WebRequest -Uri '!DIST_URL!' -OutFile '!TEMP_ZIP!' -UseBasicParsing"
    if errorlevel 1 (
        echo ERROR: Failed to download Maven. Check your internet connection.
        exit /B 1
    )

    echo [Maven Wrapper] Extracting to %USERPROFILE%\.m2\wrapper\dists ...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Expand-Archive -Path '!TEMP_ZIP!' -DestinationPath '%USERPROFILE%\.m2\wrapper\dists' -Force"
    if errorlevel 1 (
        echo ERROR: Failed to extract Maven archive.
        exit /B 1
    )
    del "!TEMP_ZIP!" 2>nul
    echo [Maven Wrapper] Maven ready at !MAVEN_HOME!
    echo.
)

:: ── Run Maven ─────────────────────────────────────────────────────────────────
"!MAVEN_HOME!\bin\mvn.cmd" %*

endlocal

