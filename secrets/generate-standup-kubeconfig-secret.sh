#!/usr/bin/env bash

declare -A provider_installations
provider_installations[aws]=gaia
provider_installations[azure]=godsmack
provider_installations[kvm]=gorgoth

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
tmp_dir="$script_dir/tmp"
result_kubeconfig="$tmp_dir/result_kubeconfig"
service_account="test-infra"

function cleanup() {
    rm -rf "$tmp_dir"
}

trap cleanup EXIT

# for provider in aws azure kvm; do
for provider in aws; do
    installation=${provider_installations[$provider]}
    echo "creating $provider kubeconfig for $installation"

    installation_kubeconfig="$tmp_dir/tmp-kubeconfig"
    KUBECONFIG=$installation_kubeconfig opsctl create kubeconfig -i $installation --certificate-common-name-prefix test-infra --ttl 30 > /dev/null

    server=$(KUBECONFIG=$installation_kubeconfig kubectl config view -o jsonpath='{.clusters[].cluster.server}')
    secret_name=$(KUBECONFIG=$installation_kubeconfig kubectl -n giantswarm get serviceaccount $service_account -o jsonpath='{.secrets[].name}')
    token=$(KUBECONFIG=$installation_kubeconfig kubectl -n giantswarm get secret/"$secret_name" -o jsonpath='{.data.token}' | base64 --decode)

    KUBECONFIG=$installation_kubeconfig kubectl -n giantswarm get secret/"$secret_name" -o jsonpath='{.data.ca\.crt}' > "$tmp_dir/ca_cert"

    rm "$installation_kubeconfig"

    touch "$result_kubeconfig"
    KUBECONFIG="$result_kubeconfig" kubectl config set-cluster "giantswarm-cluster-$installation" --server="$server" --certificate-authority="$tmp_dir/ca_cert" --embed-certs=true

    KUBECONFIG="$result_kubeconfig" kubectl config set-context "giantswarm-cluster-$installation" --cluster "giantswarm-cluster-$installation" --user "giantswarm-user-$installation"
    KUBECONFIG="$result_kubeconfig" kubectl config set-credentials "giantswarm-user-$installation" --token="$token"
done

kubectl create secret generic standup-kubeconfig -n test-workloads --from-file=kubeconfig="$result_kubeconfig" --dry-run=client -o yaml > "$script_dir/standup-kubeconfig-secret.yaml"
