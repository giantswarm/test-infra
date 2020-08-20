SHELL := /bin/bash

.PHONY: tasks
tasks:
	kubectl create -f tasks --dry-run -o yaml | kubectl -n nightly apply -f -

.PHONY: pipelines
pipelines:
	kubectl create -f pipelines --dry-run -o yaml | kubectl -n nightly apply -f -

.PHONY: reload
reload:
	@$(MAKE) tasks
	@$(MAKE) pipelines

.PHONY: clean
clean:
	kubectl delete -n nightly pipelines --all
	kubectl delete -n nightly tasks --all
