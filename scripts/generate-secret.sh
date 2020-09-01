declare -A provider_installations
provider_installations[aws]=gaia
provider_installations[azure]=ghost
provider_installations[kvm]=geckon

flags=""
KUBECONFIG=temp-kubeconfig
for provider in aws azure kvm; do
    installation=${provider_installations[$provider]}
    echo "creating $provider kubeconfig for $installation"
    opsctl create kubeconfig -i $installation --certificate-common-name-prefix test-infra --ttl 30 > /dev/null
done

kubectl config view --flatten > $KUBECONFIG.flattened
mv $KUBECONFIG.flattened $KUBECONFIG

kubectl create secret generic standup-kubeconfig --from-file=kubeconfig=$KUBECONFIG --dry-run -o yaml > standup-kubeconfig-secret.yaml
rm $KUBECONFIG
