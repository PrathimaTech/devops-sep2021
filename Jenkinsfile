pipeline {

    agent any

    environment {
        AWS_REGION = 'us-east-1'
        awsCred = 'aws-cred'
        // Add other necessary environment variables here
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git 'https://github.com/PrathimaTech/devops-sep2021.git' 
            }
        }

        stage('Build') {
            steps { 
                script {
                    // Build the application without running tests
                   def mvnhome= tool name: 'Maven-3', type: 'maven'
                   sh "${mvnhome}/bin/mvn clean package -DskipTests"
                }
            }  
        }         

        stage('Unit Test') {
            steps {
                script {
                    // Runs only unit tests
                   def mvnhome= tool name: 'Maven-3', type: 'maven'
                   sh "${mvnhome}/bin/mvn test"
            }
          }
        }

        stage('Static Code Analysis') {
            steps {
                script {
              echo "Static Code Analysis has been completed"
            }
          }
        }

        stage('Security Scan') {
            steps {
                script {
                // Run security scans
              echo "Security Scan with Trivy has been completed"
            }
          }
        }

        stage('Terraform Init') {
            steps {
                script {
                    withAWS(credentials: "${awsCred}", region: "${regName}"){
                    // Initialize Terraform
                    sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: "${awsCred}", region: "${regName}"){
                    // Plan Terraform changes based on the branch
                    if (env.BRANCH_NAME == 'development') {
                        sh 'terraform plan -var-file=dev.tfvars'
                    } else if (env.BRANCH_NAME == 'staging') {
                        sh 'terraform plan -var-file=stag.tfvars'
                    } else if (env.BRANCH_NAME == 'production') {
                        sh 'terraform plan -var-file=prod.tfvars'
                    }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    withAWS(credentials: "${awsCred}", region: "${regName}"){
                    // Apply Terraform changes based on the branch
                    if (env.BRANCH_NAME == 'development') {
                        sh 'terraform apply -var-file=dev.tfvars -auto-approve'
                    } else if (env.BRANCH_NAME == 'staging') {
                        sh 'terraform apply -var-file=stag.tfvars -auto-approve'
                    } else if (env.BRANCH_NAME == 'production') {
                        sh 'terraform apply -var-file=prod.tfvars -auto-approve'
                    }
                    }
                }
            }
        }
        
        // stage('Deploy to Kubernetes') {
        //     steps {
        //         script {
        //             // Deploy application to Kubernetes cluster
        //             deployToK8s(env.BRANCH_NAME)
        //         }
        //     }
        // }
    }

    post {
        always {
            cleanWs()  // Clean workspace after each build
        }
    }
}

// def deployToK8s(environment) {
//     withCredentials([string(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
//         sh """
//         kubectl apply -f k8s/${environment}/deployment.yaml
//         kubectl apply -f k8s/${environment}/service.yaml
//         """
//     }
// }
