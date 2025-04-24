#!/bin/bash

echo "Injecting runtime environment variables into env-config.js..."

cat <<EOF > /app/public/env-config.js
window.__ENV__ = {
  PRODUCT_SERVICE_URL: "${PRODUCT_SERVICE_URL}",
  ORDER_SERVICE_URL: "${ORDER_SERVICE_URL}",
  CART_SERVICE_URL: "${CART_SERVICE_URL}"
};
EOF

echo "✅ env-config.js injected with runtime values."

exec "$@"
