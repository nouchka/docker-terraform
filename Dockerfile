FROM alpine
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-terraform"
LABEL version="latest"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG REPOSITORY=hashicorp/terraform
ARG VERSION=1.2.2
ARG FILE_SHA256SUM=2934a0e8824925beb956b2edb5fef212a6141c089d29d8568150a43f95b3a626
ARG CF_VERSION=0.6.3
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
	wget -qO- "https://github.com/cloudflare/cf-terraforming/releases/download/v${CF_VERSION}/cf-terraforming_${CF_VERSION}_darwin_amd64.tar.gz" > /tmp/archive.tgz && \
	tar xzf - -C /usr/bin/ < /tmp/archive.tgz

VOLUME /data/
WORKDIR /data/

USER developer
ENTRYPOINT [ "/usr/bin/terraform" ]
