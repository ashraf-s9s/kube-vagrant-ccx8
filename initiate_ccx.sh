echo 'Preparing python..'
echo '##################'
echo
apt-get -y install python3.7 python3-pip
ln -s /usr/bin/python3.7 /usr/bin/python
python3.7 -m pip install --upgrade pip
git clone https://github.com/severalnines/ccx8
pip3 install -r ccx8/requirements.txt

echo
echo 'Setting up PV and storage class..'
echo '#################################'
echo
kubectl create namespace ccx-operator
kubectl create -f /vagrant/storage_class.yaml
kubectl create -f /vagrant/pv.yaml

echo 
echo 'Installing minio using helm'
echo '==========================='
echo
snap install helm --classic
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install --set persistence.size=2Gi,resources.requests.memory=1Gi,persistence.storageClass=standard --version=5.0.17 minio stable/minio

echo
echo 'Appling ccx8 yamls'
echo '=================='
echo
kubectl apply -f ccx8/resources/binding.yaml
kubectl apply -f ccx8/resources/customresource.yaml
kubectl apply -f ccx8/resources/service_account.yaml
sed -i 's/10Gi/2Gi/g' ccx8/deployment.yaml
sed -i 's/20Gi/2Gi/g' ccx8/deployment.yaml
kubectl apply -f ccx8/deployment.yaml

echo
echo 'Listing out all pods,pv,pvc for all namepsaces'
echo '=============================================='
echo
kubectl get pods,pv,pvc,rs,deployment,statefulset -A
echo
echo 'DONE & GOOD LUCK!!!!!!!'
