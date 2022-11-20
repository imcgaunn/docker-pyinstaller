.SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY : help
help :
	@echo "'make help' to print this help message"
	@echo "'make tag-image' to build docker image from Dockerfile and tag it"
	@echo "'make publish-image' to publish a tagged image to the remote registry"

# NOTE: in order for these targets to work, the following variables need to be defined
# in the environment:
# DOCKER_REGISTRY_ADDRESS
# DOCKER_REGISTRY_USER
# DOCKER_REGISTRY_PASSWORD
# IMAGE_NAME
# IMAGE_TAG
IMAGE_NAME := pyinstaller-py39
IMAGE_TAG := 5.0.1
.PHONY : registry-login
registry-login :
	@echo "logging into docker registry ${DOCKER_REGISTRY_ADDRESS}"
	@echo "${DOCKER_REGISTRY_PASSWORD}" | docker login -u ${DOCKER_REGISTRY_USER} --password-stdin ${DOCKER_REGISTRY_ADDRESS}
	@echo "successfully logged in to registry!"

.PHONY : tag-image
tag-image :
	docker build -f Dockerfile-py3-amd64 . -t "${DOCKER_REGISTRY_ADDRESS}/${IMAGE_NAME}:${IMAGE_TAG}"

.PHONY : publish-image
publish-image : | registry-login
	docker push ${DOCKER_REGISTRY_ADDRESS}/${IMAGE_NAME}:${IMAGE_TAG}

