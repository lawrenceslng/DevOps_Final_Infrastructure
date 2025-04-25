#!/bin/bash

# Capture current SHAs
CART_SHA=$(cd Cart && git rev-parse HEAD)
PRODUCT_SHA=$(cd Product && git rev-parse HEAD)
ORDER_SHA=$(cd Order && git rev-parse HEAD)
FRONTEND_SHA=$(cd Frontend && git rev-parse HEAD)

# Create default previous SHAs
LAST_CART_SHA=""
LAST_PRODUCT_SHA=""
LAST_ORDER_SHA=""
LAST_FRONTEND_SHA=""

# Load previous SHAs from LATEST_SHAS.txt if it exists
if [ -f Infra/LATEST_SHAS.txt ]; then
  echo "✅ Loading previous SHAs from Infra/LATEST_SHAS.txt"
  source Infra/LATEST_SHAS.txt
  LAST_CART_SHA="$cart_service_sha"
  LAST_PRODUCT_SHA="$product_service_sha"
  LAST_ORDER_SHA="$order_service_sha"
  LAST_FRONTEND_SHA="$frontend_sha"
else
  echo "⚠️ No LATEST_SHAS.txt found, assuming first run"
fi

# Write change detection results to GitHub Actions output file
echo "cart_changed=$([[ \"$CART_SHA\" != \"$LAST_CART_SHA\" ]] && echo true || echo false)" > result.env
echo "product_changed=$([[ \"$PRODUCT_SHA\" != \"$LAST_PRODUCT_SHA\" ]] && echo true || echo false)" >> result.env
echo "order_changed=$([[ \"$ORDER_SHA\" != \"$LAST_ORDER_SHA\" ]] && echo true || echo false)" >> result.env
echo "frontend_changed=$([[ \"$FRONTEND_SHA\" != \"$LAST_FRONTEND_SHA\" ]] && echo true || echo false)" >> result.env

# Update LATEST_SHAS.txt for next run
cat <<EOF > Infra/LATEST_SHAS.txt
cart_service_sha=$CART_SHA
product_service_sha=$PRODUCT_SHA
order_service_sha=$ORDER_SHA
frontend_sha=$FRONTEND_SHA
EOF

echo "✅ New LATEST_SHAS.txt written to Infra/"
