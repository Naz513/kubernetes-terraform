/*
Name: Kubernetes Cluster
Description: Terraform to create a Jenkins Server on AWS.
Updated Date: 2022-01-01
*/

resource "aws_security_group" "KubernetesMasterNodeSG" {
  name        = "KubernetesMasterNodeSG"
  description = "Security Group for Kubernetes Master Node"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH to Master Node Server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //FIXME: Do not hardcode your IP and do not have it open to the world.
  }

  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ETCD Server Client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kube-Scheduler"
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kube-Controller-Manager"
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Traffic"
  }

  tags = {
    Name = "Master Node Security Group"
  }
}

resource "aws_security_group" "KubernetesWorkerNodeSG" {
  name        = "KubernetesWorkerNodeSG"
  description = "Security Group for Kubernetes Worker Node"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH to Worker Node Server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //FIXME: Do not hardcode your IP and do not have it open to the world.
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Traffic"
  }

  tags = {
    Name = "Worker Node Security Group"
  }
}

resource "aws_instance" "WorkerNode" {
  count = var.num_of_workers
  ami   = data.aws_ami.latest_ubuntu_ami.id
  # instance_type = var.instance_type_env["${var.instance_type}"]
  instance_type = "t2.micro"
  key_name      = "terraform-key"

  vpc_security_group_ids = [aws_security_group.KubernetesWorkerNodeSG.id]

  provisioner "remote-exec" {
    script = "./scripts/install-components.sh"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/Desktop/ssh-keys/terraform-key.pem")
  }

  tags = {
    Name = "Worker Node ${count.index}"
  }
}

resource "aws_instance" "MasterNode" {
  ami = data.aws_ami.latest_ubuntu_ami.id
  # instance_type = var.instance_type_env["${var.instance_type}"]
  instance_type = "t2.medium"
  key_name      = "terraform-key"

  vpc_security_group_ids = [aws_security_group.KubernetesMasterNodeSG.id]

  provisioner "remote-exec" {
    scripts = ["./scripts/install-components.sh", "./scripts/kube-init.sh"]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/Desktop/ssh-keys/terraform-key.pem")
  }

  tags = {
    Name = "Master Node"
  }
}
