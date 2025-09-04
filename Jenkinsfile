pipeline {
  agent any

  options {
    timestamps()
  }

  tools {
    nodejs 'nodejs'
  }

  stages {

    stage('Check Prerequisites') {
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
          script {
            echo "Checking prerequisites..."
            echo "Node.js version:"
            sh 'node -v'
            echo "NPM version:"
            sh 'npm -v'
            echo "Checking Playwright installation..."
            def playwrightCheck = sh(script: 'npx playwright --version', returnStatus: true)
            if (playwrightCheck != 0) {
              error("Playwright is not installed or not accessible. Please install it before proceeding.")
            } else {
              sh 'npx playwright --version'
              echo "Playwright is available."
            }
          }
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
          echo "Installing project dependencies..."
          sh 'npm ci'
          echo "Installing Playwright browsers..."
          sh 'npx playwright install'
          echo "Installing required Linux dependencies for browsers..."
          sh 'npx playwright install-deps'
        }
      }
    }

    stage('Run Playwright Tests') {
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
          echo "Running Playwright tests..."
          sh 'npx playwright test --reporter=html'
        }
      }
    }

    stage('Publish Test Report') {
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
          echo "Publishing Playwright HTML report..."
          publishHTML([
            reportDir: 'playwright-report',
            reportFiles: 'index.html',
            reportName: 'Playwright Report',
            keepAll: true,
            alwaysLinkToLastBuild: true,
            allowMissing: true
          ])
          echo "Report available in Jenkins: Playwright Report tab."
        }
      }
    }
  }

  post {
    success {
      wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
        echo "Pipeline completed successfully!"
      }
    }
    failure {
      wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
        echo "Pipeline failed. Please check the stage logs above."
      }
    }
  }
}
