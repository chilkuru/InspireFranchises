// =============================================================================
// Jenkinsfile — Inspire Brands Franchising Selenium Automation Pipeline
//
// Parameterized declarative pipeline. Supports:
//   • Brand profile selection  (arbys | all-brands)
//   • TestNG group filter      (all | smoke | regression)
//   • Headless toggle          (always true in CI — no display available)
//
// Reports:
//   • JUnit XML  → Jenkins test results (trend graph, per-test history)
//   • Extent HTML report → archived artifact; download from build page
//
// Prerequisites (fulfilled by jenkins/Dockerfile):
//   • JDK 21
//   • Google Chrome (headless)
//   • Maven wrapper (./mvnw) — downloads Maven 3.9.9 automatically
// =============================================================================

pipeline {

    agent any

    // ── Build parameters ───────────────────────────────────────────────────────
    parameters {
        choice(
            name: 'BRAND_PROFILE',
            choices: ['arbys', 'baskin-robbins', 'all-brands'],
            description: 'Maven profile — which brand(s) to test'
        )
        choice(
            name: 'TEST_GROUPS',
            choices: ['all', 'smoke', 'regression'],
            description: 'TestNG groups filter.\n"all" runs every test in the selected profile.'
        )
        booleanParam(
            name: 'HEADLESS',
            defaultValue: true,
            description: 'Run Chrome in headless mode (required in CI — no display available)'
        )
    }

    // ── Global environment ─────────────────────────────────────────────────────
    environment {
        // Increase Maven heap for compilation + test execution
        MAVEN_OPTS = '-Xmx1024m -XX:+TieredCompilation'
        // Suppress WebDriverManager download progress noise in logs
        WDM_LOG_LEVEL = 'WARN'
    }

    // ── Pipeline stages ────────────────────────────────────────────────────────
    stages {

        stage('Checkout') {
            steps {
                checkout scm
                // Ensure the Unix Maven wrapper script is executable
                sh 'chmod +x mvnw'
            }
        }

        stage('Compile') {
            steps {
                echo "Compiling source and test classes..."
                sh './mvnw clean compile test-compile -q'
            }
        }

        stage('Test') {
            steps {
                script {
                    // Build the Maven command
                    def cmd = "./mvnw test -P ${params.BRAND_PROFILE} -Dheadless=${params.HEADLESS}"

                    // Append group filter only when a specific group is requested
                    if (params.TEST_GROUPS && params.TEST_GROUPS != 'all') {
                        cmd += " -Dgroups=${params.TEST_GROUPS}"
                    }

                    echo "Running: ${cmd}"
                    // Use 'returnStatus: true' so the pipeline captures failures
                    // and still archives reports before marking the build failed
                    def exitCode = sh(script: cmd, returnStatus: true)

                    // Stash exit code for use in post block
                    env.TEST_EXIT_CODE = exitCode.toString()

                    if (exitCode != 0) {
                        currentBuild.result = 'FAILURE'
                        error("Tests failed — Maven exited with code ${exitCode}. Check archived Extent report.")
                    }
                }
            }
        }

    }

    // ── Post-build actions (always run) ───────────────────────────────────────
    post {

        always {
            // Publish JUnit XML results → enables Jenkins test trend graphs.
            // Pattern targets only the top-level TEST-TestSuite.xml (the combined
            // suite report). The recursive **/*.xml glob would also pick up
            // per-<test>-block XMLs from target/surefire-reports/<suite>/junitreports/
            // causing each TC to appear 4x in Jenkins (once per XML file that
            // references it). Using TEST-*.xml avoids that duplication.
            junit(
                testResults: 'target/surefire-reports/TEST-*.xml',
                allowEmptyResults: true,
                skipPublishingChecks: false
            )

            // Archive the full Extent HTML report + screenshots
            archiveArtifacts(
                artifacts: 'test-output/extent-reports/**',
                allowEmptyArchive: true,
                fingerprint: false
            )

            // Archive the automation log
            archiveArtifacts(
                artifacts: 'test-output/logs/automation.log',
                allowEmptyArchive: true
            )

            echo "=== Build Summary ==="
            echo "Profile  : ${params.BRAND_PROFILE}"
            echo "Groups   : ${params.TEST_GROUPS}"
            echo "Headless : ${params.HEADLESS}"
            echo "Result   : ${currentBuild.currentResult}"
            echo "Extent report archived under: test-output/extent-reports/"
        }

        success {
            echo "✅ All tests PASSED for profile '${params.BRAND_PROFILE}'"
        }

        failure {
            echo "❌ Tests FAILED for profile '${params.BRAND_PROFILE}'. Download the Extent report from Artifacts."
        }

    }
}
