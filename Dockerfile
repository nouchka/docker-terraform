FROM golang:alpine
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-terraform"
LABEL version="latest"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG REPOSITORY=hashicorp/terraform
ARG VERSION=0.15.4
ARG FILE_SHA256SUM=ddf9b409599b8c3b44d4e7c080da9a106befc1ff9e53b57364622720114e325c
ENV FILE_URL https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip

WORKDIR /tmp
RUN apk --update add git wget unzip && \
	wget -qO- "${FILE_URL}" > /tmp/archive && \
	sha256sum /tmp/archive && \
	echo "${FILE_SHA256SUM}  /tmp/archive"| sha256sum -c - && \
	unzip /tmp/archive -d /usr/bin && \
	chmod +x /usr/bin/terraform && \
	rm -rf /tmp/* /var/tmp/* && \
	export uid=${PUID} gid=${PGID} && \
	echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
	echo "developer:x:${uid}:" >> /etc/group && \
	mkdir -p /home/developer && \
	chown "${uid}:${gid}" -R /home/developer && \
	go get -u github.com/cloudflare/cf-terraforming/... && \
	mv /go/bin/cf-terraforming /usr/bin/cf-terraforming

VOLUME /data/
WORKDIR /data/

USER developer
ENTRYPOINT [ "/usr/bin/terraform" ]
