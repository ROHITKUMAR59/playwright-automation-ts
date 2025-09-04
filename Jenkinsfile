pipeline {
  agent any

  options {
    ansiColor('xterm')
    timestamps() // adds timestamps for better traceability
  }

  tools {
    nodejs 'nodejs' // Jenkins -> Manage Jenkins -> Tools -> NodeJS installations
  }

  stages {

    stage('Check Prerequisites') {
      steps {
        script {
          echo "🔍 Checking prerequisites..."

          echo "➡️ Node.js version:"
          sh 'node -v'

          echo "➡️ NPM version:"
          sh 'npm -v'

          echo "➡️ Checking Playwright installation..."
          def playwrightCheck = sh(script: 'npx playwright --version', returnStatus: true)
          if (playwrightCheck != 0) {
            error("\033[0;31m❌ Playwright is not installed or not accessible. Please install it before proceeding.\033[0m")
          } else {
            sh 'npx playwright --version'
            echo "\033[0;32m✅ Playwright is available.\033[0m"
          }
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        echo "📦 Installing project dependencies..."
        sh 'npm ci'

        echo "🌐 Installing Playwright browsers (if needed)..."
        sh 'npx playwright install'
      }
    }

    stage('Run Playwright Tests') {
      steps {
        echo "🎭 Running Playwright tests..."
        sh 'npx playwright test --reporter=html'
      }
    }

    stage('Publish Test Report') {
      steps {
        echo "📊 Publishing Playwright HTML report..."
        publishHTML([
          reportDir: 'playwright-report',
          reportFiles: 'index.html',
          reportName: 'Playwright Report',
          keepAll: true,
          alwaysLinkToLastBuild: true,
          allowMissing: true
        ])
        echo "\033[0;34m🔗 Report available in Jenkins: Playwright Report tab.\033[0m"
      }
    }
  }

  post {
    success {
      echo "\033[0;32m✅ Pipeline completed successfully!\033[0m"
    }
    failure {
      echo "\033[0;31m❌ Pipeline failed. Please check the stage logs above.\033[0m"
    }
  }
}
