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
ssh-keygen -t ed25519 -q -N '' -C "$(gh repo view --json name -q '.name')" -f "${tmpdir}/id"
nameWithOwner=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
gh secret set "${privateKey}" -b"$(cat "${tmpdir}"/id)" --app actions --repo "${nameWithOwner}"
gh repo deploy-key add "${tmpdir}/id.pub" --title "${nameWithOwner}" --repo "${otherRepo}"
