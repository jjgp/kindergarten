FROM python:3.9.2-alpine3.13

LABEL maintainer="Jason Prasad <jasongprasad@gmail.com>"

RUN apk add --no-cache git \
    && pip install pre-commit
