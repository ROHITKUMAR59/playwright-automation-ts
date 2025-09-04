pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/playwright:v1.55.0-focal-20230905'
            // Increase shared memory for browser tests + cache playwright browsers
            args '--shm-size=2g -v $HOME/.cache/ms-playwright:/home/jenkins/.cache/ms-playwright'
        }
    }

    options {
        timestamps()
        ansiColor('xterm')   // instead of wrapping every stage
    }

    stages {

        stage('Check Prerequisites') {
            steps {
                script {
                    echo "Checking Node.js and NPM versions..."
                    sh 'node -v && npm -v'

                    echo "Checking Playwright CLI..."
                    sh 'npx playwright --version'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing project dependencies with npm ci..."
                sh 'npm ci'

                echo "Installing Playwright browsers (using cache)..."
                sh 'npx playwright install --with-deps'
            }
        }

        stage('Run Playwright Tests') {
            steps {
                echo "Running Playwright tests..."
                sh 'npx playwright test --reporter=html,junit'
            }
        }

        stage('Publish Test Report') {
            steps {
                echo "Publishing Playwright HTML report..."
                publishHTML([
                    reportDir: 'playwright-report',
                    reportFiles: 'index.html',
                    reportName: 'Playwright Report',
                    keepAll: true,
                    alwaysLinkToLastBuild: true,
                    allowMissing: true
                ])

                junit 'test-results/**/*.xml' // picks up junit output from Playwright
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs above."
        }
        always {
            cleanWs()  // cleanup workspace after each run
        }
    }
}
