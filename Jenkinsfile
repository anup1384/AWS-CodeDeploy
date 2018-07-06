pipeline {
  agent {
    node {
      label 'master'
    }
  }
  stages {
    stage('Checkout SCM') {
      steps {
        git credentialsId: 'afc16152-41f0-45b4-851d-be1ef0d08374',
        poll: false, url: 'https://gitlab.com/anup/anup-java.git'
      }
    }
    stage('Build job') {
      steps {
        sh '''mvn -Ppord clean package'''
      }
    }
    stage('Create Artifact') {
      steps {
        sh '''sudo mkdir -p /tmp/jenkins && sudo chmod 0700 /tmp/jenkins && \
            sudo tar -czf /tmp/jenkins/anup-routing-$BUILD_NUMBER.tar.gz \
                target/anup_routing_engine-0.0.1-SNAPSHOT.war scripts appspec.yml'''
      }
    }
    stage('Upload Artifact') {
      steps {
        retry(2) {
            sh '''sudo aws s3 cp /tmp/jenkins/anup-routing-$BUILD_NUMBER.tar.gz s3://anup-routing/'''
        }
      }
    }
    stage('Deploy Artifac') {
      steps {
        sh '''sudo aws deploy create-deployment --application-name anup-routing \
              --deployment-group-name anup-routing --deployment-config-name anup-routing50\
              --s3-location bucket=anup-routing,key=anup-routing-$BUILD_NUMBER.tar.gz,bundleType=tgz \
              --region us-west-2'''
      }
    }

  }
  post {
    failure {
      echo 'Work in progress here...'
    }
  }
}


