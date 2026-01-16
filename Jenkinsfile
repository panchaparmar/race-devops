pipeline {
    agent any

    tools {
        nodejs 'nodejs'   // must match Global Tool Configuration name
    }

    environment {
        APP_NAME      = "race-devops"
        BUILD_DIR     = "dist/race-devops"
        TARGET_SERVER = "13.205.170.169"              // CHANGE THIS
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
                withCredentials([usernamePassword(
                    credentialsId: 'web01',
                    usernameVariable: 'DEPLOY_USER',
                    passwordVariable: 'DEPLOY_PASS'
                )]) {

                    // Clean target folder on IIS server
                    bat '''
                    powershell -NoProfile -Command "
                        $sec = ConvertTo-SecureString '$env:DEPLOY_PASS' -AsPlainText -Force
                        $cred = New-Object System.Management.Automation.PSCredential('$env:DEPLOY_USER', $sec)

                        Invoke-Command -ComputerName ${TARGET_SERVER} -Credential $cred -ScriptBlock {
                            if (!(Test-Path '${TARGET_PATH}')) {
                                New-Item -ItemType Directory -Path '${TARGET_PATH}'
                            }
                            Remove-Item '${TARGET_PATH}\\*' -Recurse -Force -ErrorAction SilentlyContinue
                        }
                    "
                    '''

                    // Copy Angular build to IIS using admin share
                    bat '''
                    xcopy "''' + BUILD_DIR + '''\\*" "\\\\''' + TARGET_SERVER + '''\\C$\\inetpub\\wwwroot\\angular-app\\" /E /Y /I
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Angular application deployed successfully to IIS'
        }
        failure {
            echo '❌ Deployment failed'
        }
    }
}
