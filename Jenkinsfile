
---

# Correct Jenkinsfile

Copy ONLY this into your actual `Jenkinsfile`:

:::writing{variant="document" id="56184"}
pipeline {
    agent any

    environment {

        // ACR
        ACR_NAME = "raceacr"
        ACR_LOGIN_SERVER = "raceacr.azurecr.io"

        // Docker
        IMAGE_NAME = "angular-webapp"
        TAG = "${BUILD_NUMBER}"

        // Azure App Service
        RESOURCE_GROUP = "DevOps-Test"
        APP_NAME = "race"

        // Azure Credentials
        AZURE_CLIENT_ID = credentials('azure-client-id')
        AZURE_CLIENT_SECRET = credentials('azure-client-secret')
        AZURE_TENANT_ID = credentials('azure-tenant-id')
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id')
    }

    stages {

        stage('Checkout Code') {
            steps {

                echo "Checking out source code from GitHub..."

                git branch: 'beta',
                    credentialsId: 'GitHub_User',
                    url: 'https://github.com/panchaparmar/race-devops.git'
            }
        }

        stage('Verify Tools') {
            steps {

                sh '''
                echo "Docker Version:"
                docker --version

                echo "Azure CLI Version:"
                az version
                '''
            }
        }

        stage('Docker Build') {
            steps {

                echo "Building Docker image..."

                sh '''
                docker build \
                  -t $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG .
                '''
            }
        }

        stage('Azure Login') {
            steps {

                echo "Logging into Azure..."

                sh '''
                az login --service-principal \
                  -u $AZURE_CLIENT_ID \
                  -p $AZURE_CLIENT_SECRET \
                  --tenant $AZURE_TENANT_ID

                az account set \
                  --subscription $AZURE_SUBSCRIPTION_ID
                '''
            }
        }

        stage('ACR Login') {
            steps {

                echo "Logging into Azure Container Registry..."

                sh '''
                az acr login --name $ACR_NAME
                '''
            }
        }

        stage('Push Docker Image') {
            steps {

                echo "Pushing Docker image to ACR..."

                sh '''
                docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG
                '''
            }
        }

        stage('Deploy to Azure App Service') {
            steps {

                echo "Deploying container to Azure App Service..."

                sh '''
                az webapp config container set \
                  --name $APP_NAME \
                  --resource-group $RESOURCE_GROUP \
                  --docker-custom-image-name $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG \
                  --docker-registry-server-url https://$ACR_LOGIN_SERVER
                '''
            }
        }

        stage('Restart Azure App Service') {
            steps {

                echo "Restarting Azure App Service..."

                sh '''
                az webapp restart \
                  --name $APP_NAME \
                  --resource-group $RESOURCE_GROUP
                '''
            }
        }

        stage('Cleanup Local Docker Images') {
            steps {

                echo "Cleaning up unused Docker images..."

                sh '''
                docker image prune -f
                '''
            }
        }
    }

    post {

        success {

            echo "======================================"
            echo "Application deployed successfully!"
            echo "https://${APP_NAME}.azurewebsites.net"
            echo "======================================"
        }

        failure {

            echo "======================================"
            echo "Pipeline failed!"
            echo "Check Jenkins console logs."
            echo "======================================"
        }
    }
}
:::

After updating:

1. Commit Jenkinsfile
2. Push to `beta` branch
3. Run Jenkins pipeline again

Your previous syntax error will be resolved.
