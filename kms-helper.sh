#!/bin/bash
# Wrapper to encrypt/decrypt with AWS KMS
# Requirements:
# - AWS CLI v2
# - AWS profiles configured at ~/.aws/config or ~/.aws/credentials

# VARIABLES
OPERATION="${1}"
SECRET="${2}"
ENV="${3}"
OUTPUT_FORMAT="text"
AWS_REGION="eu-west-1"
CONFIG_PATH="./kms-helper.config"
AWS_CLI="aws"

usage() {
    echo "Usage: ./kms-helper.sh <encrypt/decrypt> <plaintext/encrypted> <account>"
    exit 1
}

checkAWSCLI() {
    if ! command -v "${AWS_CLI}"
    then
        echo "AWS CLI not found, please check your PATH or install it"
    fi
}

loadAWSconfig() {
    if ! source "${CONFIG_PATH}" 
    then
        echo "Failed to load configuration file"
        exit 1
    fi
}

encrypt() {
    PLAINTEXT=$(echo -n "${SECRET}" | base64)
    ENCRYPT=$(${AWS_CLI} kms encrypt --key-id "${KEY}" --plaintext "${PLAINTEXT}" --output "${OUTPUT_FORMAT}" --region "${AWS_REGION}" --profile "${PROFILE}" --query "${QUERY}")
    echo "${ENCRYPT}"
}

decrypt() {
    DECRYPT=$(${AWS_CLI} kms decrypt --key-id "${KEY}" --ciphertext-blob "${SECRET}" --output "${OUTPUT_FORMAT}" --region "${AWS_REGION}" --profile "${PROFILE}" --query "${QUERY}" | base64 -D)
    echo "${DECRYPT}"
}

checkKMS() {
    # Check AWS KMS key
    if [[ "${ENV}" == "pro" ]]
    then
        KEY="${PRO_KMS_KEY}"
        PROFILE="${PRO_AWS_PROFILE}"
    elif [[ "${ENV}" == "stg" ]]
    then
        KEY="${STG_KMS_KEY}"
        PROFILE="${STG_AWS_PROFILE}"
    elif [[ "${ENV}" == "dev" ]]
    then
        KEY="${DEV_KMS_KEY}"
        PROFILE="${DEV_AWS_PROFILE}"
    else
        usage
    fi
}

checkSecret() {
    # Check secret
    if [[ "${SECRET}" == "" ]]
    then
        usage
    fi
}

selectOperation() {
    # Check operation
    if [[ "${OPERATION}" == "encrypt" ]]
    then
        QUERY="CiphertextBlob"
        encrypt
    elif [[ "${OPERATION}" == "decrypt" ]]
    then
        QUERY="Plaintext"
        decrypt
    else
        usage
    fi
}

checkAWSCLI
loadAWSconfig
checkSecret
checkKMS
selectOperation
