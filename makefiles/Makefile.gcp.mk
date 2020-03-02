# >>> gcp targets
# >> variables
REPO_OWNER?=cggaldes
REPO_NAME?=enterprise-config-connector
REPO_BRANCH?=master
FULL_REPO_NAME?=github.com/cggaldes/enterprise-config-connector
KIND_CLOUDBUILD_NAME?=cloudbuild-kcc-install-to-kind.yaml
GKE_CLOUDBUILD_NAME?=cloudbuild-kcc-install-to-gke.yaml
DEV_CLOUDBUILD_NAME?=cloudbuild-dev-to-gke.yaml
CLOUDBUILD_TRIGGER_NAME?=trigger-000
CLOUDBUILD_FILE_LOCATION?=cloudbuilds
GCP_SA_KEY_PATH?=gcp-identity/key.json
IAM_BINDING_ACTION?=add

gcp.login: ## set gcloud configs, update and login
	@gcloud config set project $(PROJECT_ID)
	@gcloud config set compute/zone $(COMPUTE_ZONE)
	@gcloud config set compute/region $(COMPUTE_REGION)
	@gcloud components update --quiet
	@gcloud auth login

gcp.create_cnrm_sa_with_role: ## create gcp service accont for kcc
	@gcloud iam service-accounts create cnrm-system
	@gcloud projects add-iam-policy-binding $(PROJECT_ID) --member="serviceAccount:cnrm-system@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/editor"

gcp.create_cnrm_sa_key: ## create gcp service account key for kcc
	@gcloud iam service-accounts keys create --iam-account cnrm-system@$(PROJECT_ID).iam.gserviceaccount.com $(GCP_SA_KEY_PATH)

gcp.create_cnrm_sa: gcp.create_cnrm_sa_with_role gcp.create_cnrm_sa_key

# >>> cloud build targets
gcp.enable-cloudbuild_api:
	@gcloud services enable cloudbuild.googleapis.com

gcp.add-iam-roles-to-cloudbuild:
	@gcloud projects $(IAM_BINDING_ACTION)-iam-policy-binding $(PROJECT_ID) --member 'serviceAccount:713334855678@cloudbuild.gserviceaccount.com' --role roles/iam.serviceAccountKeyAdmin

# >>> cloud build targets
gcp.cloudbuild-csr.create_for_kind: ## create cloud build triggers for CSR
	@gcloud beta builds triggers create cloud-source-repositories \
    --repo=$(REPO_NAME) \
    --branch-pattern=".*" \
    --build-config=$(CLOUDBUILD_FILE_LOCATION)/$(KIND_CLOUDBUILD_NAME)

gcp.cloudbuild-github.create_for_kind: ## create cloud build triggers for GitHub
	@gcloud beta builds triggers create github \
	--repo-owner=$(REPO_OWNER) \
	--repo-name=$(REPO_NAME) \
	--branch-pattern="^$(REPO_BRANCH)$$" \
	--build-config=$(CLOUDBUILD_FILE_LOCATION)/$(KIND_CLOUDBUILD_NAME)

# >>> common cloud build targets
gcp.cloudbuild.list: ## list gcloud build triggers
	@gcloud beta builds triggers list

gcp.cloudbuild.run: ## run cloud build trigger, override CLOUDBUILD_TRIGGER_NAME
	@gcloud beta builds triggers run $(CLOUDBUILD_TRIGGER_NAME) \
	--branch="$(REPO_BRANCH)"

gcp.cloudbuild.delete: ## delete cloud build trigger
	@gcloud beta builds triggers delete $(CLOUDBUILD_TRIGGER_NAME)
