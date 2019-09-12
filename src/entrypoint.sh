#!/bin/sh

scriptDir=$(dirname ${0})

source ${scriptDir}/tf_fmt.sh

if [ "${INPUT_TERRAFORM_VERSION}" != "" ]; then
  tfVersion=${INPUT_TERRAFORM_VERSION}
else
  echo "Input terraform_version cannot be empty"
  exit 1
fi

function installTerraform {
  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"
  echo "Downloading Terraform v${tfVersion}"
  curl -s -L -o /tmp/terraform_${tfVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terraform v${tfVersion}"
  fi
  unzip -d /usr/local/bin /tmp/terraform_${tfVersion}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Terraform v${tfVersion}"
  fi
}

function debug {

  pwd
  ls -la
  printenv
  cat ${GITHUB_EVENT_PATH}
}

installTerraform
terraformFmt
debug
