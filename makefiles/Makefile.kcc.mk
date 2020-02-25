# >>> KCC targets
kcc.download:
	@gsutil cp gs://cnrm/latest/release-bundle.tar.gz gcp-identity/latest-install/release-bundle.tar.gz
	@cd gcp-identity/latest-install && tar zxvf release-bundle.tar.gz

# GCP Identity install
kcc.deploy: ## Deploy Config Connector to cluster
	@$(KUBECTL_PATH) $(ACTION) ns $(PROJECT_ID)
	@$(KUBECTL_PATH) $(ACTION) -f gcp-identity/latest-install/install-bundle-gcp-identity/0-cnrm-system.yaml
	@$(KUBECTL_PATH) $(ACTION) -f gcp-identity/latest-install/install-bundle-gcp-identity/crds.yaml
	@$(KUBECTL_PATH) $(ACTION) secret generic gcp-key --from-file gcp-identity/key.json --namespace cnrm-system

kcc.delete: ## Delete Config Connector to cluster
	@$(KUBECTL_PATH) $(ACTION) -f gcp-identity/latest-install/install-bundle-gcp-identity/crds.yaml
	@$(KUBECTL_PATH) $(ACTION) -f gcp-identity/latest-install/install-bundle-gcp-identity/0-cnrm-system.yaml
	@$(KUBECTL_PATH) $(ACTION) ns $(PROJECT_ID)

# KCC Common
kcc.list_available_resources: ## list available GCP resources
	@$(KUBECTL_PATH) get crds --selector cnrm.cloud.google.com/managed-by-kcc=true

kcc.list_specific_resource_crd: ## list available GCP resources
	@$(KUBECTL_PATH) get crd $(CRD_NAME) -o json
	
kcc.show_pods: ## list kcc pods
	@$(KUBECTL_PATH) get pods -n cnrm-system

kcc.show_logs: ## show kcc logs from cluster
	@$(KUBECTL_PATH) logs cnrm-controller-manager-0 -n cnrm-system -f

kcc.validate: ## validate kcc deployment
	@$(KUBECTL_PATH) wait -n cnrm-system --for=condition=Initialized pod cnrm-controller-manager-0