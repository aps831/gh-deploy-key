# GH Deploy Key

This repository provides scripts for adding and removing SSH deploy keys to GitHub repositories.

To create a deploy key use:

```bash
curl -s -L https://raw.githubusercontent.com/aps831/gh-deploy-key/${TAG}/create.sh | bash -s -- <private_key_name> <owner/repo>
```

where `<private_key_name>` is the name of the secret holding the SSH private key, eg
`SSH_PRIVATE_KEY`, and `<owner/repo>` is the repository that access is required for.

To delete a deploy key use:

```bash
curl -s -L https://raw.githubusercontent.com/aps831/gh-deploy-key/${TAG}/delete.sh | bash -s -- <private_key_name> <owner/repo>
```
