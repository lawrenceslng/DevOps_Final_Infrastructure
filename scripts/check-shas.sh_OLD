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

# Prepare result.env file
echo "cart_changed=$([[ \"$CART_SHA\" != \"$LAST_CART_SHA\" ]] && echo true || echo false)" > result.env
echo "product_changed=$([[ \"$PRODUCT_SHA\" != \"$LAST_PRODUCT_SHA\" ]] && echo true || echo false)" >> result.env
echo "order_changed=$([[ \"$ORDER_SHA\" != \"$LAST_ORDER_SHA\" ]] && echo true || echo false)" >> result.env
echo "frontend_changed=$([[ \"$FRONTEND_SHA\" != \"$LAST_FRONTEND_SHA\" ]] && echo true || echo false)" >> result.env

# Also save current SHAs to be reused later
mkdir -p new-shas
echo "$CART_SHA" > new-shas/cart.sha
echo "$PRODUCT_SHA" > new-shas/product.sha
echo "$ORDER_SHA" > new-shas/order.sha
echo "$FRONTEND_SHA" > new-shas/frontend.sha
