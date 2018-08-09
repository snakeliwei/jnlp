FROM jenkins/jnlp-slave:alpine

LABEL MAINTAINER="Lyndon.li"

RUN apk --update --no-cache add docker curl
