#!/bin/bash

source ../.env
set -e  # Stop if any command fails

# Example usage:
# MICROSERVICE_REPOS=("cart-service" "order-service" "product-service")

# These variables must be set
GITHUB_USER="lawrenceslng"
GITHUB_TOKEN=$Github_Personal_Access_Token
MICROSERVICE_REPOS=("DevOps_Final_Frontend")

# Function to promote a repo
promote_microservice() {
  local REPO=$1

  echo "🚀 Promoting $REPO..."

  # Get the current VERSION content
  VERSION=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    https://api.github.com/repos/$GITHUB_USER/$REPO/contents/VERSION \
    | jq -r '.content' | base64 -d)

  echo "Current VERSION for $REPO: $VERSION"

  # Check if already an green version
  if [[ "$VERSION" == *-green ]]; then
    echo "⚠️ $REPO already has -green, skipping..."
    return
  fi

#   echo "Here we check current version and bump it accordingly..."
#   echo "We can add logic to do fancier semantic versioning, but for now we'll just do a simple increment."

  # Parse and increment
  BASE_VERSION=$(echo "$VERSION" | cut -d'-' -f1)  # Strip any existing suffix like -rc
#   PATCH=$(echo "$BASE_VERSION" | awk -F. '{print $3}')
#   PATCH=$((PATCH + 1))
#   NEW_VERSION="$(echo "$BASE_VERSION" | awk -F. '{print $1 "." $2}').$PATCH-rc-1"

#   echo "New VERSION for $REPO: $NEW_VERSION"

  # Prepare new VERSION content
  BASE_VERSION=$(echo "$VERSION" | cut -d'-' -f1)  # Strip any existing suffix like -rc
  NEW_VERSION="${BASE_VERSION}-green"
  echo "New VERSION for $REPO: $NEW_VERSION"

  # Get the file SHA (required by GitHub API to update a file)
  SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    https://api.github.com/repos/$GITHUB_USER/$REPO/contents/VERSION \
    | jq -r '.sha')

  # Prepare updated VERSION file payload
  UPDATED_CONTENT=$(echo -n "$NEW_VERSION" | base64)

  # Make a PUT request to update the VERSION file
  curl -X PUT -H "Authorization: Bearer $GITHUB_TOKEN" \
    https://api.github.com/repos/$GITHUB_USER/$REPO/contents/VERSION \
    -d @- <<EOF
{
  "message": "Promotion to Green after UAT approval: $NEW_VERSION",
  "content": "$UPDATED_CONTENT",
  "branch": "main",
  "sha": "$SHA"
}
EOF

  echo "✅ $REPO updated to $NEW_VERSION."
}

# Loop through all microservices
for REPO in "${MICROSERVICE_REPOS[@]}"; do
  promote_microservice "$REPO"
done

echo "🎉 All requested microservices have been bumped and promoted to Green Deployment!"
