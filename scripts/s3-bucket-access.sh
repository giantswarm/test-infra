#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Make sure your ~/.aws/credentials looks something like this:
# [giantswarm]
# aws_access_key_id = <key>
# aws_secret_access_key = <secret>
# [giantswarm_admin]
# role_arn = arn:aws:iam::084190472784:role/GiantSwarmAdmin
# source_profile = giantswarm
# mfa_serial = <serial>
# region = eu-central-1

BUCKET_NAME="automated-test-results.giantswarm.io"
IAM_USER_NAME="AutomatedTestsBot"
IAM_POLICY_NAME="AutomatedTestResultsBucketAccess"
DEFAULT_REGION="eu-central-1"

echo "Creating bucket..."
aws s3api create-bucket \
    --profile giantswarm_admin \
    --bucket "$BUCKET_NAME" --acl private \
    --region "$DEFAULT_REGION" \
    --create-bucket-configuration LocationConstraint="$DEFAULT_REGION"

echo "Blocking public access to bucket..."
aws s3api put-public-access-block \
    --profile giantswarm_admin \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "Setting lifecycle rule to delete files after a week..."
aws s3api put-bucket-lifecycle-configuration \
    --profile giantswarm_admin \
    --bucket "$BUCKET_NAME" \
    --lifecycle-configuration file://"$SCRIPT_DIR/resources/bucket-lifecycle-configuration"

echo "Creating policy to allow access to bucket..."
aws iam create-policy \
    --profile giantswarm_admin \
    --policy-name  "$IAM_POLICY_NAME" \
    --policy-document file://"$SCRIPT_DIR/resources/iam-policy" \
    --description "Grants access to the bucket where our automated tests store their results"

echo "Getting policy arn..."
policy_arn=$(aws iam --profile giantswarm_admin list-policies --query 'Policies[?PolicyName==`'$IAM_POLICY_NAME'`].Arn' --output text)

echo "Creating iam user..."
aws iam create-user \
    --profile giantswarm_admin \
    --user-name "$IAM_USER_NAME"

echo "Attaching policy to user..."
aws iam attach-user-policy \
    --profile giantswarm_admin \
    --user-name "$IAM_USER_NAME" \
    --policy-arn "$policy_arn"

echo "Creating access key for user. Use $SCRIPT_DIR/resources/secret-access-key to create the s3-bucket-credentials secret..."
aws iam create-access-key \
    --profile giantswarm_admin \
    --user-name "$IAM_USER_NAME" > "$SCRIPT_DIR/resources/secret-access-key"
