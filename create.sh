#! /bin/bash
set -e

privateKey=$1
thisRepo=$2
otherRepo=$3

if [[ ${privateKey} == "" || ${thisRepo} == "" || ${otherRepo} == "" ]]; then
  echo "usage: private key name, this repo and other repo name must be supplied"
  exit 1
fi

tmpdir=$(mktemp -d)
function cleanup {
  rm -rf "${tmpdir}"
}
trap cleanup EXIT
otherRepoUrl=$(gh repo view "${otherRepo}" --json url -q '.url')
ssh-keygen -t ed25519 -q -N '' -C "${otherRepoUrl}" -f "${tmpdir}/id"
gh secret set "${privateKey}" -b"$(cat "${tmpdir}"/id)" --app actions --repo "${thisRepo}"
if [[ ${thisRepo} == "${otherRepo}" ]]; then
  gh repo deploy-key add "${tmpdir}/id.pub" --title "${thisRepo}" --repo "${otherRepo}" --allow-write
else
  gh repo deploy-key add "${tmpdir}/id.pub" --title "${thisRepo}" --repo "${otherRepo}"
fi
