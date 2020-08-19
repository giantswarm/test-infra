FROM quay.io/giantswarm/alpine:3.12.0

ARG KUBECTL_VERSION=1.18.2
ARG SONOBUOY_VERSION=0.18.4

# Install kubectl
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/bin/kubectl

# Install sonobuoy
RUN wget -qO - "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz" | tar -C /usr/local/bin -xzf - \
    && chmod 755 /usr/local/bin/sonobuoy

RUN apk add jq

COPY run-sonobuoy-tests /usr/local/bin
