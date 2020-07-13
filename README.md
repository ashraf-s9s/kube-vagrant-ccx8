Steps
=====

1) Start the VMs:

```bash
vagrant up
```

2) Login to the Kubernetes master, escalate to sudo and run `initiate_ccx.sh` (answer all prompted questions - github login etc):

```bash
vagrant ssh master

sudo -i
./initiate_ccx.sh
```

3) Make sure all required pods are running as below, before creating a Kubernetes deployment:

```bash
$ kubectl get pods -A
...
default       ccx8-operator-78d6994c49-czlxb   1/1     Running            0          9m35s
default       minio-6cb48bc746-j452v           1/1     Running            0          9m36s
...
```

4) Update `testcluster.yaml` to suit your needs.

5) Start `dbcluster.py` using kopf:

```bash
cd ccx8
kopf run dbcluster.py

```

6) Send the deployment job to Kubernetes:

```
kubectl create -f testcluster.yaml
```
