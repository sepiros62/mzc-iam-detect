FROM alpine:latest

RUN apk update

RUN apk add --no-cache \
      bash \
      python3 \
      py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
      awscli \
    && rm -rf /var/cache/apk/*

RUN aws --version

WORKDIR /script

COPY aws_iam_detect.sh aws_iam_detect.sh
