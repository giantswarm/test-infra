#!/usr/bin/env bash

declare -A provider_installations
provider_installations[aws]=gaia
provider_installations[azure]=godsmack
provider_installations[kvm]=gorgoth

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
KUBECONFIG=temp-kubeconfig

for provider in aws azure kvm; do
    installation=${provider_installations[$provider]}
    echo "creating $provider kubeconfig for $installation"
    KUBECONFIG=$KUBECONFIG opsctl create kubeconfig -i $installation --certificate-common-name-prefix test-infra --ttl 30 > /dev/null
done

KUBECONFIG=$KUBECONFIG kubectl config view --flatten > $KUBECONFIG.flattened
mv $KUBECONFIG.flattened $KUBECONFIG

kubectl create secret generic standup-kubeconfig -n test-workloads --from-file=kubeconfig=$KUBECONFIG --dry-run=client -o yaml > "$SCRIPT_DIR"/standup-kubeconfig-secret.yaml
rm $KUBECONFIG
