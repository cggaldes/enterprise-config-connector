# >>> git
# >> variables
GIT_TAG_NAME?=part-1
GIT_TAG_MESSAGE?="$(GIT_TAG_NAME) release: refer to https://medium.com/@cggaldes"

git.list_tags: ## list git tags
	@git tag

git.create_tag: ## create git release tag
	@git tag $(GIT_TAG_NAME) -m $(GIT_TAG_MESSAGE)

git.push_tag: ## push tags
	@git push origin $(GIT_TAG_NAME)