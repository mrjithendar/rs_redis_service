pipeline {

    agent any

    environment {
        tfDir = "terraform"
        region = "us-east-1"
        AWSCreds = credentials('awsCreds')
        AWS_ACCESS_KEY_ID = "${AWSCreds_USR}"
        AWS_SECRET_ACCESS_KEY = "${AWSCreds_PSW}"
        AWS_DEFAULT_REGION = "us-east-1"
        AWS_ACCOUNT_ID = "826334059644"
        vault = credentials('vaultToken')
        tfvars = "vars/${params.Options}.tfvars"
        eks_cluster_name = "roboshop-eks-cluster-demo"
        service = "redis_demo"
    }

    stages {


        stage ('Authentication') {
            steps {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                sh "aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ${eks_cluster_name}"
            }
        }

        stage ('Deploy App') {
            steps {
                sh "curl -LO https://raw.githubusercontent.com/mrjithendar/tools/master/namespace.sh"
                sh "sh namespace.sh"
                sh "kubectl apply -f k8s/redis.yml"
                sh "kubectl apply -f k8s/service.yml"
            }
        }
    }
}
