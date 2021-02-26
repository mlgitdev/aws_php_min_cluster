#!/bin/bash
# Build the Docker images
typeset -l OWNER_NAME
typeset -l VERSION
typeset -l ARTIFACTORY_URL
VERSION="1.0.2"
TF_VERSION="0.14.7"
# Verify Online the AWS-CLI exact version
AWSCLI_Version="2.0.30"
GLIBC_VERSION="2.30-r0"
APPLICATION_ID="terraform-aws-cli"
OWNER="DevOps"
OWNER_NAME=$OWNER
DOCKER_FILE="Dockerfile_TF_AWSCLI"
BUILD_DIR="."


#Build Docker
docker build \
    -t tf-aws-cli:${VERSION} \
    --build-arg TF_VERSION=${TF_VERSION} \
    --build-arg AWS_CLI_VERSION=${AWSCLI_Version} \
    --build-arg VERSION=${VERSION} \
    --build-arg GLIBC_VERSION=${GLIBC_VERSION} \
    --build-arg APPLICATION_ID=${APPLICATION_ID} \
    --build-arg OWNER=${OWNER} \
    -f ${DOCKER_FILE} \
    ${BUILD_DIR}
