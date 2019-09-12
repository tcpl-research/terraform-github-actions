#!/bin/sh

if [ "${INPUT_TERRAFORM_VERSION}" != "" ]; then
  tfVersion=${INPUT_TERRAFORM_VERSION}
else
  echo "Input terraform_version cannot be empty"
  exit 1
fi

function installTerraform {
  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"
  curl -s -L -o /tmp/terraform_${tfVersion} ${url}
}

pwd
ls -la
printenv
