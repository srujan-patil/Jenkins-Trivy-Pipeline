pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker1')
    }

    stages {
        stage('Pull Docker Image from Docker Hub') {
            steps {
                script {
                    echo "Pulling Docker Image from Docker Hub..."
                    sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
                    sh 'docker pull srujanpanthula/jenkins-nodejs-app'
                }
            }
        }

        stage('Install Trivy') {
            steps {
                script {
                    echo "Installing Trivy..."
                    // Install Trivy without sudo by extracting it in the current directory
                    sh '''
                    wget https://github.com/aquasecurity/trivy/releases/download/v0.56.2/trivy_0.56.2_Linux-64bit.tar.gz
                    tar zxvf trivy_0.56.2_Linux-64bit.tar.gz
                    chmod +x trivy
                    '''
                }
            }
        }

        stage('Security Scan with Trivy') {
            steps {
                script {
                    echo "Scanning Docker Image with Trivy..."
                    // Save Trivy scan result to a file
                    sh './trivy image --format table --output trivy-report.txt srujanpanthula/jenkins-nodejs-app'
                    // Display scan result in Jenkins console
                    sh 'cat trivy-report.txt'
                }
            }
        }

        stage('Approval for Deployment') {
            steps {
                script {
                    echo "Waiting for approval to proceed..."
                    userInput = input(
                        id: 'Proceed1', message: 'Do you approve the scan results to proceed with deployment?', 
                        parameters: [choice(name: 'Approval', choices: ['Yes', 'No'], description: 'Approve to continue')]
                    )
                    
                    if (userInput == 'No') {
                        error "Approval denied. Stopping the pipeline."
                    }
                }
            }
        }

        stage('Run Docker Container') {
            when {
                expression {
                    return userInput == 'Yes'
                }
            }
            steps {
                script {
                    echo "Running Docker Container..."
                    sh 'docker run -d -p 3000:3000 srujanpanthula/jenkins-nodejs-app'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
