DOCKER_IMAGE=terraform

include Makefile.docker

PACKAGE_VERSION=0.1

include Makefile.package

.PHONY: check-version
check-version:
	docker run --rm $(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(VERSION) version

deb:
	mkdir -p build/usr/sbin/
	cp -Rf bin/* build/usr/sbin/
	cp bin/terraform build/usr/sbin/cf-terraforming
