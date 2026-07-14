---
name: sdet-cicd
description: >
  Generates CI/CD pipeline configurations for GitHub Actions, GitLab CI, and Jenkins.
  Trigger: When user asks to create CI/CD pipelines, GitHub Actions workflows, GitLab CI configs, Jenkinsfiles, or test automation pipelines.
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-sdet
---

# CI/CD Pipeline Generator

Generates pipeline configurations for common CI/CD platforms. Use this when the user needs to integrate testing into their CI/CD pipeline.

## Supported Platforms

| Platform | Config File | Notes |
|----------|-------------|-------|
| GitHub Actions | `.github/workflows/test.yml` | Primary target |
| GitLab CI | `.gitlab-ci.yml` | Secondary target |
| Jenkins | `Jenkinsfile` | Tertiary target |

## Pipeline Stages

All pipelines MUST include these stages (platform-appropriate):

1. **Checkout** — Clone repository
2. **Setup** — Install dependencies, browser binaries
3. **Lint** — Code quality checks
4. **Test** — Run test suites (S → M → L based on trigger)
5. **Report** — Generate and publish test reports
6. **Artifacts** — Save screenshots, videos, traces on failure

## GitHub Actions Template

```yaml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  smoke-tests:
    name: Smoke Tests (S)
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps chromium
      - run: npx playwright test --project=chromium --grep="@smoke"
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: smoke-test-results
          path: test-results/
          retention-days: 7

  functional-tests:
    name: Functional Tests (M)
    runs-on: ubuntu-latest
    timeout-minutes: 30
    needs: smoke-tests
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test --project=chromium --grep="@functional"
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: functional-test-results
          path: test-results/
          retention-days: 7

  regression-tests:
    name: Regression Tests (L)
    runs-on: ubuntu-latest
    timeout-minutes: 60
    needs: smoke-tests
    if: github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/tags/')
    strategy:
      matrix:
        project: [chromium, firefox, webkit]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps ${{ matrix.project }}
      - run: npx playwright test --project=${{ matrix.project }} --grep="@regression"
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: regression-test-results-${{ matrix.project }}
          path: test-results/
          retention-days: 14

  report:
    name: Test Report
    runs-on: ubuntu-latest
    needs: [smoke-tests, functional-tests, regression-tests]
    if: always()
    steps:
      - uses: actions/download-artifact@v4
        with:
          path: test-results/
      - name: Publish Test Report
        uses: dorny/test-reporter@v1
        if: always()
        with:
          name: Test Results
          path: test-results/**/*.xml
          reporter: jest-junit
```

## GitLab CI Template

```yaml
stages:
  - setup
  - test
  - report

variables:
  npm_config_cache: "$CI_PROJECT_DIR/.npm"
  PLAYWRIGHT_BROWSERS_PATH: "$CI_PROJECT_DIR/.cache/ms-playwright"

cache:
  key:
    files:
      - package-lock.json
  paths:
    - .npm/
    - .cache/ms-playwright/

.setup-template: &setup
  image: mcr.microsoft.com/playwright:v1.50.0-noble
  before_script:
    - npm ci
    - npx playwright install --with-deps

smoke-tests:
  <<: *setup
  stage: test
  script:
    - npx playwright test --grep="@smoke"
  artifacts:
    when: on_failure
    paths:
      - test-results/
    reports:
      junit: test-results/junit.xml
    expire_in: 7 days
  timeout: 10m

functional-tests:
  <<: *setup
  stage: test
  script:
    - npx playwright test --grep="@functional"
  artifacts:
    when: on_failure
    paths:
      - test-results/
    reports:
      junit: test-results/junit.xml
    expire_in: 7 days
  timeout: 30m
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

regression-tests:
  <<: *setup
  stage: test
  script:
    - npx playwright test --grep="@regression"
  artifacts:
    when: on_failure
    paths:
      - test-results/
    reports:
      junit: test-results/junit.xml
    expire_in: 14 days
  timeout: 60m
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
    - if: $CI_COMMIT_TAG

test-report:
  stage: report
  image: alpine:latest
  script:
    - echo "Test report generated"
  needs:
    - smoke-tests
    - functional-tests
    - regression-tests
  when: always
```

## Jenkinsfile Template

```groovy
pipeline {
    agent any

    parameters {
        choice(
            name: 'TEST_SUITE',
            choices: ['smoke', 'functional', 'regression', 'all'],
            description: 'Which test suite to run'
        )
    }

    stages {
        stage('Setup') {
            steps {
                sh 'npm ci'
                sh 'npx playwright install --with-deps'
            }
        }

        stage('Smoke Tests') {
            when {
                anyOf {
                    expression { params.TEST_SUITE in ['smoke', 'all'] }
                    branch 'main'
                }
            }
            steps {
                sh 'npx playwright test --grep="@smoke"'
            }
            post {
                always {
                    junit 'test-results/junit.xml'
                    archiveArtifacts artifacts: 'test-results/**', allowEmptyArchive
                }
            }
        }

        stage('Functional Tests') {
            when {
                anyOf {
                    expression { params.TEST_SUITE in ['functional', 'all'] }
                    changeRequest()
                }
            }
            steps {
                sh 'npx playwright test --grep="@functional"'
            }
            post {
                always {
                    junit 'test-results/junit.xml'
                    archiveArtifacts artifacts: 'test-results/**', allowEmptyArchive
                }
            }
        }

        stage('Regression Tests') {
            when {
                anyOf {
                    expression { params.TEST_SUITE in ['regression', 'all'] }
                    branch 'main'
                    tag pattern: "v\\d+\\.\\d+\\.\\d+", comparator: "REGEXP"
                }
            }
            steps {
                sh 'npx playwright test --grep="@regression"'
            }
            post {
                always {
                    junit 'test-results/junit.xml'
                    archiveArtifacts artifacts: 'test-results/**', allowEmptyArchive
                }
            }
        }
    }

    post {
        failure {
            slackSend(
                color: 'danger',
                message: "Test failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
        success {
            slackSend(
                color: 'good',
                message: "Tests passed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
    }
}
```

## Conditional Test Execution Strategy

| Trigger | Tests Run | Why |
|---------|-----------|-----|
| PR to main | S + M | Catch regressions before merge |
| Push to main | S + M + L | Verify merge didn't break anything |
| Tag (release) | S + M + L + XL | Full validation before release |
| Nightly | S + M + L | Catch environmental or dependency issues |
| Manual | User choice | Debug or targeted testing |

## Trigger Keywords

Load this skill when the user says any of:
- "CI/CD", "pipeline", "GitHub Actions", "GitLab CI", "Jenkinsfile"
- "test pipeline", "automation pipeline"
- "continuous integration", "continuous testing"
- "configurar CI", "pipeline de testing"
