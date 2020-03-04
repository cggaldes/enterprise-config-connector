# Kind targets
kind.create_cluster: ## create kind cluster named $(CLUSTER_NAME)
	@kind create cluster --name=$(CLUSTER_NAME)

kind.create_multi_node_cluster: ## create multi-node kind cluster named $(CLUSTER_NAME)
	@kind create cluster --name=$(CLUSTER_NAME) --config multi-node-cluster.yaml

kind.delete_cluster: ## delete kind cluster named $(CLUSTER_NAME)
	@kind delete cluster --name=$(CLUSTER_NAME)

kind.list_clusters: ## list kind clusters
	@kind get clusters