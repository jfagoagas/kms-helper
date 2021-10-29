# kms-helper
Tool to encrypt/decrypt using AWS KMS with ease.

## Requirements
 - AWS CLI v2
 - AWS profiles configured at `~/.aws/config` or `~/.aws/credentials`
 - Configuration file named `kms-helper.config` with the following structure:
```
# AWS ACCOUNT KMS KEYS
PRO_KMS_KEY=""
STG_KMS_KEY=""
DEV_KMS_KEY=""

# AWS ACCOUNT PROFILES
PRO_AWS_PROFILE=""
STG_AWS_PROFILE=""
DEV_AWS_PROFILE=""
```

## Usage
- Encrypt
`./kms-helper.sh <encrypt> <plaintext> <account>`
- Decrypt
`./kms-helper.sh <decrypt> <encrypted> <account>`
