#! /bin/bash
set -e

privateKey=$1
otherRepo=$2

if [[ ${privateKey} == "" || ${otherRepo} == "" ]]; then
  echo "usage: private key name and repo name must be supplied"
  exit 1
fi

gh secret delete "${privateKey}" || true
nameWithOwner=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
id=$(gh repo deploy-key list --json id,title --repo "${otherRepo}" | jq -c ".[] | select( .title == \"${nameWithOwner}\") | .id" | head -n 1)
gh repo deploy-key delete "${id}" --repo "${otherRepo}" || true
