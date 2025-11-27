pipeline {
    agent any
    
    options {
        timestamps()
    }
    
    environment {
        AWS_REGION = "us-east-2"
        REPO_NAME = "sm-devops-app2"
        AWS_ACCOUNT_ID = "1234567890123"
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
        stage('Terraform Init') {
            steps {
                sh """
                  cd terraform
                  terraform init
                """
            }
        }
        stage('Terraform Plan') {
            steps {
                sh """
                  cd terraform
                  terraform plan
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
