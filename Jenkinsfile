pipeline {
    agent any

    tools {
        nodejs 'NodeJS'   // must EXACTLY match Global Tool Configuration name
    }

    environment {
        APP_NAME      = "race-devops"
        BUILD_DIR     = "dist/simple-dashboard"
        TARGET_SERVER = "13.205.170.169"
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

                    // ---- CLEAN TARGET FOLDER ON IIS SERVER ----
                    bat """
                    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
                    "\$sec = ConvertTo-SecureString '%DEPLOY_PASS%' -AsPlainText -Force; ^
                     \$cred = New-Object System.Management.Automation.PSCredential('%DEPLOY_USER%', \$sec); ^
                     Invoke-Command -ComputerName ${TARGET_SERVER} -Credential \$cred -ScriptBlock { ^
                         if (!(Test-Path '${TARGET_PATH}')) { ^
                             New-Item -ItemType Directory -Path '${TARGET_PATH}' | Out-Null ^
                         }; ^
                         Remove-Item '${TARGET_PATH}\\*' -Recurse -Force -ErrorAction SilentlyContinue ^
                     }"
                    """

                    // ---- COPY BUILD FILES TO IIS SERVER ----
                    bat '''
                    xcopy "''' + BUILD_DIR + '''\\*" "\\\\''' + TARGET_SERVER + '''\\C$\\App\\race\\" /E /Y /I
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
            echo '❌ Pipeline failed'
        }
    }
}
