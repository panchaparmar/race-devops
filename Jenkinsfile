pipeline {
    agent any

    tools {
        nodejs 'NodeJS'   // MUST match Global Tool Configuration name
    }

    environment {
        APP_NAME      = "race-devops"
        BUILD_DIR     = "dist\\simple-dashboard"
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
                archiveArtifacts artifacts: "${BUILD_DIR}\\**", fingerprint: true
            }
        }

        stage('Deploy to IIS') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'web01',
                        usernameVariable: 'DEPLOY_USER',
                        passwordVariable: 'DEPLOY_PASS'
                    )
                ]) {

                    /* ---------- WinRM cleanup on target server ---------- */
                    powershell '''
                        $sec  = ConvertTo-SecureString $env:DEPLOY_PASS -AsPlainText -Force
                        $cred = New-Object System.Management.Automation.PSCredential($env:DEPLOY_USER, $sec)

                        Invoke-Command `
                          -ComputerName "${env:TARGET_SERVER}" `
                          -Credential $cred `
                          -Authentication Basic `
                          -ScriptBlock {
                              if (!(Test-Path "C:\\App\\race")) {
                                  New-Item -ItemType Directory -Path "C:\\App\\race" | Out-Null
                              }
                              Remove-Item "C:\\App\\race\\*" -Recurse -Force -ErrorAction SilentlyContinue
                          }
                    '''

                    /* ---------- Copy build files to IIS server ---------- */
                    bat """
                        xcopy "${BUILD_DIR}\\*" "\\\\${TARGET_SERVER}\\C$\\App\\race\\" /E /Y /I
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment completed successfully'
        }
        failure {
            echo '❌ Deployment failed'
        }
    }
}
