pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('aws-creds')
        SSH_KEY = credentials('ec2-ssh-key')
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ShivaniNarula29/test_dynamic_flow.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('infra') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS}"]]) {
                        sh '''
                            terraform init
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Ansible Playbook Execution') {
            steps {
                dir('ansible') {
                    withCredentials([sshUserPrivateKey(credentialsId: "${SSH_KEY}", keyFileVariable: 'SSH_KEY_PATH')]) {
                        sh '''
                            export ANSIBLE_HOST_KEY_CHECKING=False
                            ansible-playbook -i aws_ec2.yml site.yml --private-key $SSH_KEY_PATH
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Infrastructure provisioned and Prometheus installed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
