#!/bin/bash

echo "Creating GitHub Actions IAM user with ECR permissions..."

# Create IAM policy
POLICY_ARN=$(aws iam create-policy \
  --policy-name GitHubActionsECRPolicy \
  --policy-document file://github-actions-ecr-policy.json \
  --description "Minimal ECR permissions for GitHub Actions" \
  --query 'Policy.Arn' --output text)

echo "Created policy: $POLICY_ARN"

# Create IAM user
aws iam create-user \
  --user-name github-actions-user \
  --tags Key=Purpose,Value=GitHubActions Key=Service,Value=ECR

echo "Created user: github-actions-user"

# Attach policy to user
aws iam attach-user-policy \
  --user-name github-actions-user \
  --policy-arn $POLICY_ARN

echo "Attached policy to user"

# Create access keys
echo "Creating access keys..."
aws iam create-access-key \
  --user-name github-actions-user \
  --output table

echo ""
echo "IMPORTANT: Store the AccessKeyId and SecretAccessKey in GitHub Secrets as:"
echo "- AWS_ACCESS_KEY_ID"
echo "- AWS_SECRET_ACCESS_KEY"
