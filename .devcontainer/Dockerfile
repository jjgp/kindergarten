FROM docker:latest

RUN apk add --no-cache \
    curl \
    && curl -Lo kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64 \
    && chmod +x kind \
    && mv kind /usr/local/bin
