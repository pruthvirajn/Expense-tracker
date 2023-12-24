/* groovylint-disable LineLength */
pipeline {
  agent any
 
  stages {
    stage('Build') {
      steps {
        sh('sh ./build.sh')
      }
    }
    stage('Test') {
      steps {
        sh('echo test')
      }
    }
    
  }
}