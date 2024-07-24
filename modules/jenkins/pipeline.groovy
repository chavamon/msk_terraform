pipeline {
    agent any

    environment {
        EC2_PUBLIC_IP_1 = credentials('EC2_PUBLIC_IP_1')
        EC2_PUBLIC_IP_2 = credentials('EC2_PUBLIC_IP_2')
        EC2_PUBLIC_IP_3 = credentials('EC2_PUBLIC_IP_3')
        EC2_KEY = credentials('EC2_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Up JDK') {
            steps {
                tool name: 'JDK 21', type: 'jdk'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn -B clean package --file pom.xml'
            }
        }

        stage('Upload to EC2 Instances') {
            steps {
                script {
                    def instances = [env.EC2_PUBLIC_IP_1, env.EC2_PUBLIC_IP_2, env.EC2_PUBLIC_IP_3]
                    instances.each { ip ->
                        sh """
                        scp -i ${EC2_KEY} target/producer-0.0.1-SNAPSHOT.jar ec2-user@${ip}:/home/ec2-user/
                        """
                    }
                }
            }
        }

        stage('Restart Spring Boot Application on EC2 Instances') {
            steps {
                script {
                    def instances = [env.EC2_PUBLIC_IP_1, env.EC2_PUBLIC_IP_2, env.EC2_PUBLIC_IP_3]
                    instances.each { ip ->
                        sh """
                        ssh -i ${EC2_KEY} ec2-user@${ip} << EOF
                        pkill -f 'java -jar' || true
                        nohup java -jar /home/ec2-user/producer-0.0.1-SNAPSHOT.jar > /dev/null 2>&1 &
                        EOF
                        """
                    }
                }
            }
        }
    }
}