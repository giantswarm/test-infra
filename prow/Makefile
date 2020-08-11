SHELL := /bin/bash

namespace:
	kubectl apply -f cluster/namespace.yaml

cluster/oauth-token.yaml: oauth
	kubectl -n prow create secret generic --dry-run=client -o yaml oauth-token --from-file=$< >> $@

cluster/hmac-token.yaml: hmac
	kubectl -n prow create secret generic --dry-run=client -o yaml -n prow hmac-token --from-file=$< >> $@

prow: namespace cluster/oauth-token.yaml cluster/hmac-token.yaml cluster/*.yaml
	kubectl apply -f cluster

plugins: config/plugins.yaml
	kubectl create configmap plugins --from-file=plugins.yaml=config/plugins.yaml --dry-run=client -o yaml | kubectl -n prow apply -f -

configs: config/configs.yaml
	kubectl create configmap configs --from-file=configs.yaml=config/configs.yaml --dry-run=client -o yaml | kubectl -n prow apply -f -

clean:
	rm -f cluster/oauth-token.yaml
	rm -f cluster/hmac-token.yaml
