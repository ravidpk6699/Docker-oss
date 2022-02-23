def VERSION = "1.0.0"
pipeline {
    agent any
    tools {
      maven 'maven3'
    }  
    stages{
        stage('Build') {
            steps{
                sh 'mvn clean package'
                script {
                    VERSION = readMavenPom().getVersion()
                }
                echo("Build version: ${VERSION}")       
            }          
        }  
        /*stage('SonarQube analysis') {
              steps{
                  withSonarQubeEnv('SonarQube 8.9.3') { 
                  sh "mvn sonar:sonar"
                  echo 'Test'    
                 }
             }
        }
        stage("Quality Gate") {
            steps {
               //timeout(time: 1, unit: 'HOURS') {
               //waitForQualityGate abortPipeline: true
             // }
                echo 'Test'
            }
          } 
        stage('Upload war to nexus') {
            steps{
                 nexusArtifactUploader artifacts: [
                     [
                         artifactId: 'WebApp', 
                         classifier: '', 
                         file: 'target/WebApp.war', 
                         type: 'war'
                     ]
                 ], 
                 credentialsId: 'Nexuslogin', 
                 groupId: 'Demoapp', 
                 nexusUrl: '3.16.181.122:8081', 
                 nexusVersion: 'nexus3', 
                 protocol: 'http', 
                 repository: 'demo', 
                 version: "${VERSION}"
            }          
        }*/
        stage('Build Docker Image') {
                steps{
                    withCredentials([string(credentialsId: 'docker-password', variable: 'docker_hub_password')]) {
                    sh "docker login -u ravidharani -p ${docker_hub_password}"
                }
                sh "docker build -t ravidharani/ravidharani-javadocker:${VERSION} ."
                sh "docker tag ravidharani/ravidharani-javadocker:${VERSION} ravidharani/ravidharani-javadocker:latest"
                sh "docker push ravidharani/ravidharani-javadocker:${VERSION}"
                sh "docker push ravidharani/ravidharani-javadocker:latest" 
            }
        }
        stage('Deploy to prod') {
            steps{
                ansiblePlaybook become: true, becomeUser: 'root', credentialsId: 'ansible', inventory: 'ansible/hosts', playbook: 'ansible/deploy.yaml'
            }          
        }
        
            }          
        }
    

