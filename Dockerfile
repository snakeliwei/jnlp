FROM openjdk:8-jdk-alpine
LABEL MAINTAINER = "lyndon.li"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG VERSION=3.27
ARG AGENT_WORKDIR=/home/${user}/agent

RUN apk add --update --no-cache curl bash git openssh-client openssl procps docker \
  && curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

ENV HOME /home/${user}
RUN addgroup -g ${gid} ${group}
RUN adduser -D -h $HOME -u ${uid} -g ${gid} -G docker ${user}

# USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
