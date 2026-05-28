pipeline {
    agent any

    environment {
        ACR_NAME = "raceacr"
        IMAGE_NAME = "angular-webapp"
        TAG = "${BUILD_NUMBER}"

        ACR_LOGIN_SERVER = "raceacr.azurecr.io"

        AZURE_CLIENT_ID = credentials('azure-client-id')
        AZURE_CLIENT_SECRET = credentials('azure-client-secret')
        AZURE_TENANT_ID = credentials('azure-tenant-id')
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id')

        ACR_USERNAME = credentials('acr-username')
        ACR_PASSWORD = credentials('acr-password')

        RESOURCE_GROUP = "DevOps-Test"
        APP_NAME = "race"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'beta',
                    credentialsId: 'GitHub_User',
                    url: 'https://github.com/panchaparmar/race-devops.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG .
                """
            }
        }

        stage('ACR Login') {
            steps {
                sh """
                docker login $ACR_LOGIN_SERVER \
                -u $ACR_USERNAME \
                -p $ACR_PASSWORD
                """
            }
        }

        stage('Push Image') {
            steps {
                sh """
                docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG
                """
            }
        }

        stage('Azure Login') {
            steps {
                sh """
                az login --service-principal \
                  -u $AZURE_CLIENT_ID \
                  -p $AZURE_CLIENT_SECRET \
                  --tenant $AZURE_TENANT_ID

                az account set \
                  --subscription $AZURE_SUBSCRIPTION_ID
                """
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                sh """
                az webapp config container set \
                  --name $APP_NAME \
                  --resource-group $RESOURCE_GROUP \
                  --docker-custom-image-name $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG \
                  --docker-registry-server-url https://$ACR_LOGIN_SERVER \
                  --docker-registry-server-user $ACR_USERNAME \
                  --docker-registry-server-password $ACR_PASSWORD
                """
            }
        }

        stage('Restart App Service') {
            steps {
                sh """
                az webapp restart \
                  --name $APP_NAME \
                  --resource-group $RESOURCE_GROUP
                """
            }
        }
    }
}
