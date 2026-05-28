pipeline {
agent any

```
environment {

    ACR_LOGIN_SERVER = "raceacr.azurecr.io"

    IMAGE_NAME = "angular-webapp"

    TAG = "${BUILD_NUMBER}"

    RESOURCE_GROUP = "DevOps-Test"

    APP_NAME = "race"
}

stages {

    stage('Checkout Code') {

        steps {

            git branch: 'beta',
                credentialsId: 'GitHub_User',
                url: 'https://github.com/panchaparmar/race-devops.git'
        }
    }

    stage('Docker Build') {

        steps {

            sh '''
            docker build \
              -t $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG .
            '''
        }
    }

    stage('ACR Login') {

        steps {

            withCredentials([
                usernamePassword(
                    credentialsId: 'acr-credentials',
                    usernameVariable: 'ACR_USERNAME',
                    passwordVariable: 'ACR_PASSWORD'
                )
            ]) {

                sh '''
                echo "$ACR_PASSWORD" | docker login $ACR_LOGIN_SERVER \
                -u "$ACR_USERNAME" \
                --password-stdin
                '''
            }
        }
    }

    stage('Push Docker Image') {

        steps {

            sh '''
            docker push \
              $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG
            '''
        }
    }

    stage('Deploy Info') {

        steps {

            echo "Image pushed successfully"

            echo "Image URL:"
            echo "$ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG"
        }
    }
}

post {

    success {

        echo "================================="
        echo "Docker image pushed successfully"
        echo "================================="
    }

    failure {

        echo "================================="
        echo "Pipeline failed"
        echo "================================="
    }
}
```

}
