FROM alpine

# Install sonobuoy version 0.18.4
RUN wget -qO - "https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.18.4/sonobuoy_0.18.4_linux_amd64.tar.gz" | tar -C /usr/local/bin -xzf - \
    && chmod 755 /usr/local/bin/sonobuoy

COPY run-sonobuoy-tests /usr/local/bin
