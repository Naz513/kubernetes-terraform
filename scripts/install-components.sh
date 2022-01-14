#!/usr/bin/env bash
echo "###################################################################################"
echo "# DOCKER INSTALLATION                                                             #"
echo "###################################################################################"
echo " "

echo "###################################################################################"
echo "# 1/12 Uninstall old versions                                                     #"
echo "###################################################################################"
sudo apt-get remove docker docker-engine docker.io containerd runc
echo " "

echo "###################################################################################"
echo "# 2/12 Set up the repository                                                      #"
echo "###################################################################################"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
echo " "

echo "###################################################################################"
echo "# 3/12 Add Docker’s official GPG key                                              #"
echo "###################################################################################"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo " "

echo "###################################################################################"
echo "# 4/12 Set up the stable repository                                               #"
echo "###################################################################################"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo ""

echo "###################################################################################"
echo "# 5/12 Install Docker Engine                                                      #"
echo "###################################################################################"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
echo " "

echo "###################################################################################"
echo "# 6/12 Run docker as normal user                                                  #"
echo "###################################################################################"
sudo usermod -aG docker $USER
echo " "

echo "-----------------------------------------------------------------------------------"
echo " INSTALLING KUBERENTES COMPONENETS"
echo "-----------------------------------------------------------------------------------"
echo " "

echo "###################################################################################"
echo "# 7/12 Install apt package index & Install Kubernetes repository                  #"
echo "###################################################################################"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
echo " "

echo "###################################################################################"
echo "# 8/12 Download the Google Cloud public signing key                               #"
echo "###################################################################################"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo " "

echo "###################################################################################"
echo "# 9/12 Add the Kubernetes apt repository                                          #"
echo "###################################################################################"
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo " "

echo "###################################################################################"
echo "# 10/12 Install kubelet, kubeadm and kubect                                       #"
echo "###################################################################################"
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
echo " "

echo "###################################################################################"
echo "# 11/12 Configure the Docker daemon to use systemd                                #"
echo "###################################################################################"
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
echo " "

echo "###################################################################################"
echo "# 12/12 Restart Docker and enable on boot                                         #"
echo "###################################################################################"
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
echo " "