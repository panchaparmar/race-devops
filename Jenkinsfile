pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    environment {
        BUILD_DIR     = 'dist\\simple-dashboard'
        TARGET_SERVER = '13.205.170.169'
        TARGET_PATH   = 'C:\\App\\race'
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
                archiveArtifacts artifacts: 'dist\\simple-dashboard\\**', fingerprint: true
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

                    /* ---------- Prepare IIS server ---------- */
                    powershell '''
                        $sec  = ConvertTo-SecureString $env:DEPLOY_PASS -AsPlainText -Force
                        $cred = New-Object System.Management.Automation.PSCredential($env:DEPLOY_USER, $sec)

                        Invoke-Command `
                          -ComputerName '13.205.170.169' `
                          -Credential $cred `
                          -Authentication Basic `
                          -ScriptBlock {
                              if (!(Test-Path 'C:\\App\\race')) {
                                  New-Item -ItemType Directory -Path 'C:\\App\\race' | Out-Null
                              }
                              Remove-Item 'C:\\App\\race\\*' -Recurse -Force -ErrorAction SilentlyContinue
                          }
                    '''

                    /* ---------- Copy files via SMB ---------- */
                    bat '''
                        xcopy "dist\\simple-dashboard\\*" "\\\\13.205.170.169\\C$\\App\\race\\" /E /Y /I
                    '''
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
