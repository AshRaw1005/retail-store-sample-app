#!/bin/bash

# Create IAM policy for GitHub Actions ECR access
aws iam create-policy \
  --policy-name GitHubActionsECRPolicy \
  --policy-document file://github-actions-ecr-policy.json \
  --description "Minimal permissions for GitHub Actions to push to ECR"

# Create IAM user for GitHub Actions
aws iam create-user \
  --user-name github-actions-ecr-user

# Attach policy to user
aws iam attach-user-policy \
  --user-name github-actions-ecr-user \
  --policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/GitHubActionsECRPolicy

# Create access keys (store these securely in GitHub Secrets)
aws iam create-access-key \
  --user-name github-actions-ecr-user
