echo "###################################################################################"
echo "# Install Kubernetes Dashboard                                                    #"
echo "###################################################################################"
echo " "

echo "###################################################################################"
echo "# 1/5 Kube Apply Dashboard Manifest File                                          #"
echo "###################################################################################"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
echo " "

echo "###################################################################################"
echo "# 2/5 Expose the Service                                                          #"
echo "###################################################################################"
kubectl expose deployment kubernetes-dashboard --type=NodePort --name=kube-dash -n kubernetes-dashboard
echo " "

echo "###################################################################################"
echo "# 3/5 Create a cluster-admin to access the dashboard                              #"
echo "###################################################################################"
kubectl create serviceaccount cluster-admin-dashboard-sa
kubectl create clusterrolebinding cluster-admin-dashboard-sa --clusterrole=cluster-admin --serviceaccount=default:cluster-admin-dashboard-sa
echo " "

echo "###################################################################################"
echo "# 4/5 Get the Token                                                               #"
echo "###################################################################################"
kubectl describe secret $(kubectl get secret | awk '/^cluster-admin-dashboard-sa-token-/{print $1}') | awk '$1=="token:"{print $2}'
echo " "

echo "###################################################################################"
echo "# 5/5 Get the port                                                                #"
echo "###################################################################################"
kubectl get svc -n kubernetes-dashboard
echo " "