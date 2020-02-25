# Infrastructure as Code…but not as you know it
## enterprise-config-connector - part 1
A demonstration of Google's Kubernetes Config Connector (KCC).

## Pre-requisites
- [gcloud sdk](https://cloud.google.com/sdk/install)
- [kind](https://github.com/kubernetes-sigs/kind)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- GCP Account and Project
- Cloud IAM account with Project Owner
- Fork of [github.com/cggaldes/enterprise-config-connector](https://github.com/cggaldes/enterprise-config-connector)

## 1.0 Clone repo
```
git clone github.com/cggaldes/enterprise-config-connector
```


Details on how do do this can be found here: 
https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository

## 1.1 Create kind cluster running on your local machine
```
CLUSTER_NAME=name-your-cluster make kind.create_cluster
```

## 1.2 Deploy kcc using gcp identity (gcp service account auth via key)
Update the following value in the Makefile:

Specify target GCP Project:
```
PROJECT_ID?=gcp-project-id
```

Create GCP service account for KCC:

```
# create service account
gcloud iam service-accounts create cnrm-system

# bind iam policy to service account
gcloud projects add-iam-policy-binding $(PROJECT_ID) - member="serviceAccount:cnrm-system@$(PROJECT_ID).iam.gserviceaccount.com" --role="roles/owner"

# create key for service account
gcloud iam service-accounts keys create --iam-account cnrm-system@$(PROJECT_ID).iam.gserviceaccount.com gcp-identity/key.json

OR

make gcp.create_cnrm_sa
```

Deploy KCC:
```
# create namespace that aligns to the name of your GCP project
kubectl create ns $(PROJECT_ID)

# deploy KCC manifests using kubectl
kubectl apply -f gcp-identity/latest-install/install-bundle-gcp-identity/0-cnrm-system.yaml
kubectl apply -f gcp-identity/latest-install/install-bundle-gcp-identity/crds.yaml

# deploy service account key as kubernetes secret
kubectl apply secret generic gcp-key --from-file gcp-identity/key.json --namespace cnrm-system

OR 

# install kcc to cluster
make kcc.deploy

# validate kcc deploy
make kcc.validate

# expected result = pod/cnrm-controller-manager-0 condition met
```

## 1.3 Deploy Cloud Storage bucket

Cloud Storage bucket spec:
```
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  labels:
    env: "poc"
  name: demo.ecc.christophergaldes.com
  annotations:
    cnrm.cloud.google.com/force-destroy: true
spec:
  website:
    mainPageSuffix: index.html
```

Update Cloud Storage bucket name:
```
BUCKET_NAME=name-your-bucket make update_object_name_references
```

Deploy Cloud Storage bucket:
```
# Create cloud storage bucket
make app.demo1.deploy_bucket

# tail logs
make kcc.show_logs
```

Deploy sample website to storage bucket:
```
# Sync site contents to bucket
make app.demo1.deploy_website
```

## 1.4 Configure Cloud Storage bucket (optional)
Verify domain name, instructions at:
https://console.cloud.google.com/apis/credentials/domainverification


Add CNAME entry for domain name:
```
DNS -> c.storage.googleapis.com
```

## Summary

Refer to https://medium.com/@cggaldes for more details