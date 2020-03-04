# >>> Demo 1
app.demo1.deploy_bucket: ## Demo 1: deploy cloud storage bucket
	@$(KUBECTL_PATH) $(ACTION) -k gcp-foundations/overlays/test/ -n $(PROJECT_ID)

app.demo1.deploy_website: ## Demo 1: deploy website to cloud storage bucket
	@./gcp-foundations/overlays/test/site_uploader.sh

app.demo1.deploy: app.demo1.deploy_bucket app.demo1.deploy_website

# >>> Demo 2
app.demo2.deploy: ## Demo 2: deploy GCP network
	@$(KUBECTL_PATH) $(ACTION) -k gcp-foundations/overlays/sharedservices/ -n $(PROJECT_ID)

app.demo2.sleep:
	@sleep 300