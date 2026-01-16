pipeline {
    agent any

    tools {
        nodejs 'nodejs'   // MUST match Global Tool Configuration name
    }

    environment {
        APP_NAME      = "race-devops"
        BUILD_DIR     = "dist/race-devops"
        TARGET_SERVER = "13.205.170.169"      // CHANGE THIS
        TARGET_PATH   = "C:\\App\\race"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
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

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: "${BUILD_DIR}/**", fingerprint: true
            }
        }

        stage('Deploy to IIS') {
            when {
                branch 'main'
            }
            steps {
                echo "Deploying Angular app to IIS..."
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
