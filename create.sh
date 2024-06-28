#! /bin/bash
set -e

privateKey=$1
otherRepo=$2

if [[ ${privateKey} == "" || ${otherRepo} == "" ]]; then
  echo "usage: private key name and repo name must be supplied"
  exit 1
fi

tmpdir=$(mktemp -d)
function cleanup {
  rm -rf "${tmpdir}"
}
trap cleanup EXIT
thisRepoNameWithOwner=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
otherRepoUrl=$(gh repo view "${otherRepo}" --json url -q '.url')
ssh-keygen -t ed25519 -q -N '' -C "${otherRepoUrl}" -f "${tmpdir}/id"
gh secret set "${privateKey}" -b"$(cat "${tmpdir}"/id)" --app actions --repo "${thisRepoNameWithOwner}"
if [[ ${thisRepoNameWithOwner} == "${otherRepo}" ]]; then
  gh repo deploy-key add "${tmpdir}/id.pub" --title "${thisRepoNameWithOwner}" --repo "${otherRepo}" --allow-write
else
  gh repo deploy-key add "${tmpdir}/id.pub" --title "${thisRepoNameWithOwner}" --repo "${otherRepo}"
fi
