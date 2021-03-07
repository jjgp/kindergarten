FROM jjgp/kindergarten:kube

ENV AWS_IAM_AUTHENTICATOR_VERSION=1.19.6/2021-01-05
ENV EKSCTL_VERSION=0.40.0
ENV GLIBC_VER=2.33-r0
RUN apk add --no-cache \
    curl \
    unzip \
    # glibc
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk \
    # aws-cli
    && curl -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
    # aws-iam-authenticator
    && curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/$AWS_IAM_AUTHENTICATOR_VERSION/bin/linux/amd64/aws-iam-authenticator \
    && curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/$AWS_IAM_AUTHENTICATOR_VERSION/bin/linux/amd64/aws-iam-authenticator.sha256 \
    && cat aws-iam-authenticator.sha256 | sed "s/ /  /" | sha256sum -c - \
    && chmod +x ./aws-iam-authenticator \
    && mv aws-iam-authenticator /usr/local/bin \
    && rm aws-iam-authenticator.sha256 \
    # eksctl
    && curl -sL "https://github.com/weaveworks/eksctl/releases/download/$EKSCTL_VERSION/eksctl_$(uname -s)_amd64.tar.gz" | tar xz \
    && mv eksctl /usr/local/bin \
    && apk --no-cache del \
        curl \
        unzip \
    && rm glibc-${GLIBC_VER}.apk \
    && rm glibc-bin-${GLIBC_VER}.apk \
    && rm -rf /var/cache/apk/*
