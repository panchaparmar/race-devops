pipeline {
    agent any

    tools {
        nodejs 'nodejs'
    }

    environment {
        APP_NAME = "race-devops"
        BUILD_DIR = "dist/simple-dashboard"
        TARGET_SERVER = "13.205.170.169"
        TARGET_PATH = "C:\\App\\race"
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

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: "${BUILD_DIR}/**", fingerprint: true
            }
        }

        stage('Deploy to IIS') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'web01',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {

                    bat """
                    powershell -Command "
                    \$sec = ConvertTo-SecureString '\$env:PASS' -AsPlainText -Force
                    \$cred = New-Object System.Management.Automation.PSCredential('\$env:USER', \$sec)

                    Invoke-Command -ComputerName ${TARGET_SERVER} -Credential \$cred -ScriptBlock {
                        if (!(Test-Path '${TARGET_PATH}')) {
                            New-Item -ItemType Directory -Path '${TARGET_PATH}'
                        }
                        Remove-Item '${TARGET_PATH}\\*' -Recurse -Force
                    }
                    "
                    """

                    bat """
                    xcopy "${BUILD_DIR}\\*" "\\\\${TARGET_SERVER}\\C$\\inetpub\\wwwroot\\angular-app\\" /E /Y /I
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful 🎉'
        }
        failure {
            echo 'Deployment failed ❌'
        }
    }
}
