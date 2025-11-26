pipeline {
    agent any
    
    //options {
    //    timestamps()
    //}
    
    environment {
        AWS_REGION = "us-east-2"
        REPO_NAME = "sm-devops-app2"
        AWS_ACCOUNT_ID = "760474663805"
        //ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/srikanthmanam1/sm-a4-p1_git-jenkins-docker-terraform.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                  docker build -t ${REPO_NAME}:latest .
                """
            }
        }

/*        stage('Run Docker Container') {
            steps {
                echo 'Run Docker Container'
                script {
                    sh 'docker run --rm ${REPO_NAME}:latest'
                }
            }
        }
*/
/*        stage('AWS ECR Login') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                  docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                """
            }
        }

        stage('Tag & Push Image') {
            steps {
                sh """
                  docker tag ${REPO_NAME}:latest ${ECR_URL}:latest
                  docker push ${ECR_URL}:latest
                """
            }
        }
*/
        stage('Terraform Init') {
            steps {
                sh """
                  cd terraform
                  terraform init
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                  cd terraform
                  terraform apply -auto-approve
                """
            }
        }
    }
}

