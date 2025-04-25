#!/bin/bash

# List of repositories you want to retag
REPOSITORIES=(
  "cart-service"
  "frontend"
  "order-service"
  "product-service"
)

# Target tag
TARGET_TAG="RC-1"
# Source tag
SOURCE_TAG="nightly-latest"

for REPO in "${REPOSITORIES[@]}"; do
  echo "Processing repository: $REPO"
  
  MANIFEST=$(aws ecr batch-get-image \
    --repository-name "$REPO" \
    --image-ids imageTag=$SOURCE_TAG \
    --output text \
    --query 'images[].imageManifest')
  
  aws ecr put-image \
    --repository-name "$REPO" \
    --image-tag $TARGET_TAG \
    --image-manifest "$MANIFEST"
  
  echo "Retagged $REPO:$SOURCE_TAG -> $TARGET_TAG"
done