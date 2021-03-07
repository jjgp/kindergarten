FROM jjgp/kindergarten:latest as base
FROM docker:latest

LABEL maintainer="Jason Prasad <jasongprasad@gmail.com>"

COPY --from=base /usr/local/bin/kfctl /usr/local/bin
COPY --from=base /usr/local/bin/kubectl /usr/local/bin

ENV KIND_VERSION=v0.10.0
RUN apk add --no-cache \
    curl \
    # kind
    && curl -L -o kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64 \
    && chmod +x kind \
    && mv kind /usr/local/bin \
    && apk --no-cache del \
        curl
