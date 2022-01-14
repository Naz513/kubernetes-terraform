# Deploy Jenkins Using Terraform
Deploy a Kubernetes Cluster under 5 mins!

## Resources Created by this Template
- Jenkins Server [EC2 Instance]
- Jenkins Security Group [Security Group]

## Template Flow
1. User defines the type of Environment this server will be installed in.
2. Terraform creates 1 Secuirty Group by dynamically attaching it to the default VPC details.
3. Terraform will search for the latest AWS AMZN AMI.
4. Terraform will create the EC2 Instance.

## Environment Options
Based on the environment users enter, the type of instance will be launched. 
dev  = "t2.micro"
test = "t2.medium"
prod = "t2.large"

## Outputs
1. Instance IP
2. AMZN AMI
3. Jenkins Admin Password

## Management
All resources are built and tested using [Terraform,](https://www.terraform.io/) and stored in [Github](https://github.com/Naz513/jenkins-terraform).

## How to use?
### Pre-requisites
- AWS Account
- Basic AWS Knowledge
- Familiar with Terraform

### How to Install this template
Download this repo to your local machine or clone the repo.

### Run the following commands in your terminal
```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Jenkins setup
After the terraform process has been completed. The Terraform command will provide the IP of the Server, copy that and paste it on your browser.
Copy the Admin Password from the Terraform outputs and paste it on the Jenkins browser.
And you are all set!

### AWS 
1. Go to AWS, and search for EC2
2. In EC2 Instances, you will see a new Instance was created named "Jenkins Server".
3. You can also check out the Security Group by going to the Security Group page.