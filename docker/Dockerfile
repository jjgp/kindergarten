FROM alpine:3.13

LABEL maintainer="Jason Prasad <jasongprasad@gmail.com>"

ENV KFCTL_VERSION=v1.2.0
ENV KUBECTL_VERSION=v1.20.4
RUN apk add --no-cache \
    curl \
    # kfctl
    && curl -sL https://api.github.com/repos/kubeflow/kfctl/releases \
        | grep "browser_download_url.*$KFCTL_VERSION.*linux" \
        | cut -d '"' -f 4 \
        | xargs curl -sL \
        | tar xz \
    && mv kfctl /usr/local/bin \
    # kubectl
    && curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" \
    && curl -LO "https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c - \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl kubectl.sha256 \
    && apk --no-cache del \
        curl
