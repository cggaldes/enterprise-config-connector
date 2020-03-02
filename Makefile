# Variables
CLUSTER_NAME?=ecc-on-kind
PROJECT_ID?=chris-galdes-contino-project
BUCKET_NAME_PLACEHOLDER?=BUCKET-NAME-PLACEHOLDER
BUCKET_NAME?=christophergaldes.com
CRD_NAME?=containerclusters.container.cnrm.cloud.google.com

# Execution Variables
KUBECTL_PATH?=kubectl
ACTION?=apply
CREATE_ACTION?=create

# GCP Variables
COMPUTE_ZONE?=australia-southeast1-a
COMPUTE_REGION?=australia-southeast1

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

# Include all the Make files 
include makefiles/*

update_object_name_references:
	@sed -i.1_bu s/$(BUCKET_NAME_PLACEHOLDER)/$(BUCKET_NAME)/ gcp-foundations/base/website_storage_bucket/storage_v1alpha2_storagebucket.yaml
	@sed -i.2_bu s/$(BUCKET_NAME_PLACEHOLDER)/$(BUCKET_NAME)/ gcp-foundations/overlays/test/site_uploader.sh
	@sed -i.3_bu s/$(BUCKET_NAME_PLACEHOLDER)/$(BUCKET_NAME)/ gcp-foundations/overlays/test/storage-access-control.yaml
	@sed -i.4_bu s/$(BUCKET_NAME_PLACEHOLDER)/$(BUCKET_NAME)/ gcp-foundations/overlays/test/storage-default-object-access-control.yaml
	@sed -i.5_bu s/$(BUCKET_NAME_PLACEHOLDER)/$(BUCKET_NAME)/ gcp-foundations/overlays/test/storage.yaml