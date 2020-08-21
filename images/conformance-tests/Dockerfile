FROM quay.io/giantswarm/alpine:3.12.0

ARG SONOBUOY_VERSION=0.18.4

# Install sonobuoy
RUN wget -qO - "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz" | tar -C /usr/local/bin -xzf - \
    && chmod 755 /usr/local/bin/sonobuoy

# Install sonobuoy version 0.18.4
RUN wget -qO - "https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.18.4/sonobuoy_0.18.4_linux_amd64.tar.gz" | tar -C /usr/local/bin -xzf - \
    && chmod 755 /usr/local/bin/sonobuoy

RUN apk add jq

COPY run-sonobuoy-tests /usr/local/bin
