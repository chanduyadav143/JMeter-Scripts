pipeline {
    agent any

    environment {
        IMAGE_NAME = 'chanduyadav143/jmetertest:v1.0'  // Replace with your Docker image name
        TEST_REPO = 'https://github.com/chanduyadav143/JMeter-Scripts.git'  // Replace with your GitHub repo URL
    }

    stages {
        stage('Checkout Tests') {
            steps {
                // Clone your test scripts repository
                git branch: 'main', credentialsId: "${params.gitCredentialsID}", url: "${TEST_REPO}"
            }
        }
        
        stage('Run JMeter Tests') {
            steps {
                // Run JMeter Docker container with mounted test scripts directory
                sh """
                docker run --rm -v \$(pwd)/MX_Files:/tests -w /tests ${IMAGE_NAME} \
                -n -t Sample.jmx -l results.jtl -e -o /tests/report
                """
            }
        }

        stage('Archive Results') {
            steps {
                // Archive results to Jenkins for easy access
                archiveArtifacts artifacts: 'results.jtl, report/**', allowEmptyArchive: true
            }
        }
    }
}

