pipeline {
    agent any

    environment {
        APP_NAME      = "race-devops"
        BUILD_DIR     = "dist/race-devops"
        TARGET_SERVER = "13.205.170.169"
        TARGET_PATH   = "C:\\App\\race"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Node & NPM') {
            steps {
                bat 'node -v'
                bat 'npm -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Build Angular App') {
            steps {
                bat 'npm run build -- --configuration=production'
            }
        }

        stage('Deploy to IIS') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to IIS...'
            }
        }
    }
}
