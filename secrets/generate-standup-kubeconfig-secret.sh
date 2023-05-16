#!/usr/bin/env bash

declare -A provider_installations
provider_installations[aws]=gaia
provider_installations[aws-china]=giraffe
provider_installations[azure]=gremlin
provider_installations[capa]=grizzly

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
tmp_dir="$script_dir/tmp"
mkdir -p $tmp_dir

function cleanup() {
    rm -rf "$tmp_dir"
}

trap cleanup EXIT

for service_account in "test-infra" "sonobuoy"; do
  for provider in aws aws-china azure capa; do
      installation=${provider_installations[$provider]}
      echo "creating $provider kubeconfig for $service_account in $installation"

      # Create a temp kubeconfig for the installation
      installation_kubeconfig="$tmp_dir/tmp-kubeconfig-$installation"
      if [ "$provider" = "capa" ]; then
        # TODO: replace with opsctl create kubeconfig once supported
        lpass show "Shared-Team Phoenix/CAPA\kubeconfigs/$installation.kubeconfig" --notes > $installation_kubeconfig
      else
        rm -f $installation_kubeconfig
        opsctl login $installation --method clientcert --certificate-common-name-prefix $service_account --ttl 365 --self-contained $installation_kubeconfig > /dev/null
      fi

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

      # Add service account data to the kubeconfig
      (
      export KUBECONFIG="$tmp_dir/$provider-kubeconfig-$service_account"
      touch $KUBECONFIG

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

  if [ "$service_account" = "test-infra" ]; then
      kubectl create secret generic standup-kubeconfig \
        -n test-workloads \
        --from-file=aws="$tmp_dir/aws-kubeconfig-$service_account" \
        --from-file=aws-china="$tmp_dir/aws-china-kubeconfig-$service_account" \
        --from-file=azure="$tmp_dir/azure-kubeconfig-$service_account" \
        --from-file=capa="$tmp_dir/capa-kubeconfig-$service_account" \
        --dry-run=client -o yaml \
        > "$script_dir/standup-kubeconfig-secret.yaml"

      echo "Please apply $script_dir/standup-kubeconfig-secret.yaml to gorilla/rfjh2"

  else
    kubectl create secret generic $service_account-kubeconfig \
      -n test-workloads \
      --from-file=aws="$tmp_dir/aws-kubeconfig-$service_account" \
      --from-file=aws-china="$tmp_dir/aws-china-kubeconfig-$service_account" \
      --from-file=azure="$tmp_dir/azure-kubeconfig-$service_account" \
      --from-file=capa="$tmp_dir/capa-kubeconfig-$service_account" \
      --dry-run=client -o yaml \
      > "$script_dir/$service_account-kubeconfig-secret.yaml"

      echo "Please apply $script_dir/$service_account-kubeconfig-secret.yaml to gorilla/rfjh2"

  fi

done
