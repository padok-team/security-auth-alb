# Purpose

This GitHub repository contains code for deploying a proof of concept of application authentication using an Application Load Balancer (ALB) integrated with AWS Cognito.

The code deploys three applications. The first two applications are HTTP-HTTPS echo apps, with one of them protected by AWS Cognito for secure authentication, while the other is publicly accessible. The third app is an instance of Grafana, which is protected by AWS Cognito. We tried to configure AWS Cognito with it to achieve a one-step authentication.

Read this article for more information: https://security.padok.fr/en/blog/appliacation-load-balancer

# Usage

## Prerequisites

* terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

* AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

* Helm: https://helm.sh/docs/intro/install/

* direnv: https://direnv.net/

* Have a VPC and an EKS cluster deployed on AWS
  *  /!\ Do not use word "cognito" in cluster name

## Installation

* Clone this repository

* Create AWS profile "padok-lab" in ~/.aws/config, or if you want to use a profile of yours, search each occurrence of "padok-lab" and edit them with your profile name, then `direnv allow`

* Login to AWS: `aws sso login`

* Update kubeconfig : `aws eks update-kubeconfig --name '{cluster_name}'`

* Manage chart's dependency in each helm folder (app, grafana and ingress-nginx): `helm dependency update`
  
* Create terraform backend for remote state: in folder layers/0-bootstrap
   * `terraform init`
   * `terraform apply`

* Deploy HTTP-HTTPS echo apps in your cluster: in folder layers/1-backbone
   * In file locals.tf: 
     * Update local.domain_name with your domain name
     * Replace local.name with your EKS cluster name
   * `terraform init`
   * `terraform apply`

* Create the ALB and configuration: in folder layers/2-authentication
  * In file locals.tf: 
    * Update local.domain_name with your domain name
    * Replace local.name with your EKS cluster name
    * Complete vpc_id and vpc_public_subnets_ids with your VPC information
   * `terraform init`
   * `terraform apply`

* Deploy Grafana app in your cluster: in folder helm/grafana
  * in values.yaml: 
    * replace the correct values in environment variables with your cognito user pool endpoint, user pool domain, user pool client id and your domain name (in GF_AUTH_JWT_JWK_SET_URL, GF_AUTH_JWT_EXPECT_CLAIMS, GF_AUTH_SIGNOUT_REDIRECT_URL)
    *  replace hosts.host with grafana.{YOUR_DOMAIN_NAME}
  * Apply chart: `helm install grafana .`

# Licence

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
