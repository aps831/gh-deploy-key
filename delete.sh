#! /bin/bash
set -e

privateKey=$1
thisRepo=$2
otherRepo=$3

if [[ ${privateKey} == "" || ${thisRepo} == "" || ${otherRepo} == "" ]]; then
  echo "usage: private key name, this repo and other repo name must be supplied"
  exit 1
fi

gh secret delete "${privateKey}" --repo "${thisRepo}" || true
id=$(gh repo deploy-key list --json id,title --repo "${otherRepo}" | jq -c ".[] | select( .title == \"${thisRepo}\") | .id" | head -n 1)
gh repo deploy-key delete "${id}" --repo "${otherRepo}" || true
