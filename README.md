# Deploy Kubernetes Cluster Using Terraform on AWS

## Resources Created by this Template
- Worker Nodes [EC2 Instance]
- Master Node [EC2 Instance]
- Worker Nodes Security Group [Security Group]
- Master Node Security Group [Security Group]

## Template Flow
1. User defines the number of worker nodes desired for the cluster.
2. Terraform creates 2 Secuirty Groups by dynamically attaching it to the default VPC.
3. Terraform will search for the latest Ubuntu AMI.
4. Terraform will create the EC2 Instances along with the Security Groups.

## EC2 Instance Types Used
These have been hardcoded to save costs. 
WorkerNodes  = "t2.micro"
MasterNode = "t2.medium"

## Outputs
1. Worker Node IPs
2. Master Node IP
3. Master Node SSH String
4. AMI Name

## Management
All resources are built and tested using [Terraform,](https://www.terraform.io/) and stored in [Github](https://github.com/Naz513/kubernetes-terraform).

## How to use?
### Pre-requisites
- AWS Account
- Basic AWS Knowledge
- Basic Terraform Knowledge

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

### Kubernetes Cluster setup
1. After the terraform process has been completed. The Terraform command will provide the join token that will be used to attach worker nodes to the master node.
```bash
EXAMPLE: 
sudo kubeadm join IP-ADDRESS:PORT --token
--discovery-token-ca-cert-hash sha256:
```
2. Copy the Join Token.
3. SSH into the Worker Nodes and Enter the Join Token using root (sudo).
4. Go back to Master node and enter "kubectl get nodes". If the worker nodes are successfully joined, the above command should show all the worker node along with the master node in "Ready" state.

### AWS 
1. Go to AWS, and search for EC2
2. In EC2 Instances, you will see the worker nodes along with the master node.
3. You can also check out the Security Groups by going to the Security Group page.

### To delete the cluster run the following commands in your terminal
```bash
terraform destroy
```