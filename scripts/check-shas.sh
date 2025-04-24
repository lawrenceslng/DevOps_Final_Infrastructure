#!/bin/bash

mkdir -p old-shas

# Get current SHAs
CART_SHA=$(cd Cart && git rev-parse HEAD)
PRODUCT_SHA=$(cd Product && git rev-parse HEAD)
ORDER_SHA=$(cd Order && git rev-parse HEAD)
FRONTEND_SHA=$(cd Frontend && git rev-parse HEAD)

# Get previous SHAs from file if they exist
LAST_CART_SHA=$(cat old-shas/cart.sha 2>/dev/null || echo "")
LAST_PRODUCT_SHA=$(cat old-shas/product.sha 2>/dev/null || echo "")
LAST_ORDER_SHA=$(cat old-shas/order.sha 2>/dev/null || echo "")
LAST_FRONTEND_SHA=$(cat old-shas/frontend.sha 2>/dev/null || echo "")

# Compare and output results
[ "$CART_SHA" != "$LAST_CART_SHA" ] && echo "cart_changed=true" || echo "cart_changed=false"
[ "$PRODUCT_SHA" != "$LAST_PRODUCT_SHA" ] && echo "product_changed=true" || echo "product_changed=false"
[ "$ORDER_SHA" != "$LAST_ORDER_SHA" ] && echo "order_changed=true" || echo "order_changed=false"
[ "$FRONTEND_SHA" != "$LAST_FRONTEND_SHA" ] && echo "frontend_changed=true" || echo "frontend_changed=false"

# Also save current SHAs to be reused later
mkdir -p new-shas
echo "$CART_SHA" > new-shas/cart.sha
echo "$PRODUCT_SHA" > new-shas/product.sha
echo "$ORDER_SHA" > new-shas/order.sha
echo "$FRONTEND_SHA" > new-shas/frontend.sha
