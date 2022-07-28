FROM ubuntu:rolling
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-terraform"
LABEL version="latest"

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

ARG REPOSITORY=hashicorp/terraform
ARG VERSION=1.2.6
ARG FILE_SHA256SUM=9fd445e7a191317dcfc99d012ab632f2cc01f12af14a44dfbaba82e0f9680365
ARG CF_VERSION=0.8.0
ENV FILE_URL https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip

WORKDIR /tmp
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install --no-install-recommends -y git=* wget=* ca-certificates=* unzip=* && \
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
	echo "https://github.com/cloudflare/cf-terraforming/releases/download/v${CF_VERSION}/cf-terraforming_${CF_VERSION}_linux_amd64.tar.gz" && \
	wget -qO- "https://github.com/cloudflare/cf-terraforming/releases/download/v${CF_VERSION}/cf-terraforming_${CF_VERSION}_linux_amd64.tar.gz" > /tmp/archive.tgz && \
	tar xzf - -C /usr/bin/ < /tmp/archive.tgz

VOLUME /data/
WORKDIR /data/

USER developer
ENTRYPOINT [ "/usr/bin/terraform" ]
