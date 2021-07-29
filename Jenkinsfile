pipeline { 
    
    environment { 
        registryCredential = 'Docker_Hub_Credentials'
        imagename = "jundevops/maven"
        dockerImage = ''
    }
    parameters {
        choice(choices: ['apply','destroy'], description: 'CHOOSE ACTION.' , name: 'ACTION')
        choice(choices: ['staging','production','all'], description: 'CHOOSE SERVERS TO DEPLOY.' , name: 'HOSTS')
        string(name: 'BUILDS', defaultValue : 'latest', description: 'ENTER BUILD NUMBER/TAG TO DEPLOY.')  
        }
        
    agent { label 'ubuntu' }
    
    options {
        timestamps ()
        ansiColor('xterm')
        
    }
    stages {
        
        stage('Git') { 
            steps { 
                echo '====== Pulling git ======'
                git credentialsId: 'GitHub', url: 'git@github.com:JuniorDevOps/Project_29.07.git' 
            }
        } 
        
        stage('Infra Provisioning') {
            steps {
                echo '====== Infrastructure provisioning ======'
                dir ('Terraform') {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_Credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                script {
                sh "terraform init -input=false"
                sh "terraform plan -input=false"
                sh "terraform ${params.ACTION} -auto-approve"
                        }      
                    }
                }
            }  
        }      
        
        stage('Maven Build/Test') {
            when { expression { params.ACTION == "apply" } 
                   expression { params.BUILDS == "latest" }
                 }  
            steps {
                echo '====== Build/Test Application ======'
                dir ('Project_29.07/spring-petclinic/') {
                sh "./mvnw package"
                sh "cd target && mv *.jar myapp.jar && mv myapp.jar ~/jenkins/workspace/${JOB_NAME}/Docker"
                }              
            }
        }

        stage('Image Build') {
            when { expression { params.ACTION == "apply" } 
                   expression { params.BUILDS == "latest" }
                 }
            steps {
                echo '====== Building Application Docker Image ======'
                script {
                    dir ('Docker') { 
                    dockerImage = docker.build imagename
                    }
                }
            }
        }
        
        stage('Image Delivery') {
            when { expression { params.ACTION == "apply" } 
                   expression { params.BUILDS == "latest" }
                 }
            steps {
                echo '====== Pushing Application Docker Image ======'
                script {
                   docker.withRegistry( '', registryCredential ) {
                   dockerImage.push("$BUILD_NUMBER")
                   dockerImage.push('latest')
                   }
                } 
            } 
        }
    
        stage('Local Images Remove') {
            when { expression { params.ACTION == "apply" } 
                   expression { params.BUILDS == "latest" }
                 } 
            steps {
                echo '====== Remove Local Application Docker Image ======'
                sh "docker rmi $imagename:$BUILD_NUMBER"
                sh "docker rmi $imagename:latest"
            }
        }

        stage('Deploy to Stage/Prod') { 
            when { expression { params.ACTION == "apply" } }
            steps { 
                echo '====== Deployment on Target Servers ======'
                sleep 20
                dir ('Ansible') {
                script {
                sh """ansible-playbook create_container.yml --extra-vars "HOST=${params.HOSTS} BUILD=${params.BUILDS}" """
                            
                   }              
                }                
            }
        }
    }
}
