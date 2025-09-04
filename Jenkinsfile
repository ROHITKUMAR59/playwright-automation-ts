pipeline {
  agent any

  stages {
    stage('Check Prerequisites') {
      steps {
        script {
          // Check Node.js version
          sh 'node -v'

          // Check npm version
          sh 'npm -v'

          // Check if Playwright is installed globally or locally
          def playwrightCheck = sh(script: 'npx playwright --version', returnStatus: true)
          if (playwrightCheck != 0) {
            error("Playwright is not installed or not accessible. Please install it before proceeding.")
          }
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'npm ci'
        // Install Playwright browsers if not already installed
        sh 'npx playwright install'
      }
    }

    stage('Run Playwright Tests') {
      steps {
        sh 'npx playwright test --reporter=html'
      }
    }

    stage('Publish Test Report') {
      steps {
        publishHTML([
          reportDir: 'playwright-report',
          reportFiles: 'index.html',
          reportName: 'Playwright Report'
        ])
      }
    }
  }
}
