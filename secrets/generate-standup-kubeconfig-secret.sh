#!/usr/bin/env bash

declare -A provider_installations
provider_installations[aws]=gaia
provider_installations[azure]=godsmack
provider_installations[kvm]=gorgoth

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
tmp_dir="$script_dir/tmp"
service_account="test-infra"

function cleanup() {
    rm -rf "$tmp_dir"
}

trap cleanup EXIT

for provider in aws azure kvm; do
    installation=${provider_installations[$provider]}
    echo "creating $provider kubeconfig for $installation"

    # Create a temp kubeconfig for the installation
    installation_kubeconfig="$tmp_dir/tmp-kubeconfig-$installation"
    KUBECONFIG=$installation_kubeconfig opsctl create kubeconfig -i $installation --certificate-common-name-prefix test-infra --ttl 30 > /dev/null

    # Get the installation server
    server=$(KUBECONFIG=$installation_kubeconfig kubectl config view -o jsonpath='{.clusters[].cluster.server}')

    # Get the name of the secret from the CP where the service account token and cert are stored
    secret_name=$(KUBECONFIG=$installation_kubeconfig kubectl -n giantswarm get serviceaccount $service_account -o jsonpath='{.secrets[].name}')
    if [[ -z "$secret_name" ]]; then
        echo "Could not get the secret name of $service_account service account on $installation."
        echo "You can create everything you need on the CP by using the files in the control-plane folder."
        exit 1
    fi

    # Read service account token from the secret
    token=$(KUBECONFIG=$installation_kubeconfig kubectl -n giantswarm get secret/"$secret_name" -o jsonpath='{.data.token}' | base64 --decode)

    # Read service account cert from the secret
    KUBECONFIG=$installation_kubeconfig kubectl -n giantswarm get secret/"$secret_name" -o jsonpath='{.data.ca\.crt}'  | base64 --decode > "$tmp_dir/ca_cert"

    result_kubeconfig="$tmp_dir/result_kubeconfig"
    # Add service account data to the kubeconfig
    (
    touch "$result_kubeconfig"
    export KUBECONFIG="$result_kubeconfig"

    # Add data from the service account to the result kubeconfig
    kubectl config set-cluster "giantswarm-cluster-$installation" \
        --server="$server" \
        --certificate-authority="$tmp_dir/ca_cert" \
        --embed-certs=true

   kubectl config set-credentials "giantswarm-user-$installation" \
        --token="$token"

   kubectl config set-context "giantswarm-$installation" \
        --cluster "giantswarm-cluster-$installation" \
        --user "giantswarm-user-$installation"

   kubectl config use-context "giantswarm-$installation"
   )
done

kubectl create secret generic standup-kubeconfig \
    -n test-workloads \
    --from-file=kubeconfig="$result_kubeconfig" \
    --dry-run=client -o yaml \
    > "$script_dir/standup-kubeconfig-secret.yaml"
