# >>> gcp targets
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
	@gcloud iam service-accounts keys create --iam-account cnrm-system@$(PROJECT_ID).iam.gserviceaccount.com gcp-identity/key.json

gcp.create_cnrm_sa: gcp.create_cnrm_sa_with_role gcp.create_cnrm_sa_key
