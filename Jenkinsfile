pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/playwright:v1.55.0-focal'
            args '--shm-size=2g -v $HOME/.cache/ms-playwright:/home/jenkins/.cache/ms-playwright'
        }
    }

    options {
        timestamps()
    }

    stages {

        stage('Check Prerequisites') {
            steps {
                wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                    script {
                        echo "Checking Node.js version..."
                        sh 'node -v'

                        echo "Checking NPM version..."
                        sh 'npm -v'

                        echo "Checking Playwright installation..."
                        sh 'npx playwright --version'
                        echo "Playwright is available."
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
                    echo "Installing project dependencies..."
                    sh 'npm ci'

                    echo "Installing Playwright browsers (cached)..."
                    sh 'npx playwright install --with-deps'
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
                echo "Pipeline failed. Check stage logs above."
            }
        }
    }
}
