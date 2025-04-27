#!/bin/bash

NAMESPACE=prod

echo "🔵 Switching services to GREEN version..."

# only do the one that is actually promoted to green
kubectl patch service cart-service -n $NAMESPACE -p '{"spec":{"selector":{"app":"cart","version":"green"}}}'
kubectl patch service order-service -n $NAMESPACE -p '{"spec":{"selector":{"app":"order","version":"green"}}}'
kubectl patch service product-service -n $NAMESPACE -p '{"spec":{"selector":{"app":"product","version":"green"}}}'
kubectl patch service frontend-service -n $NAMESPACE -p '{"spec":{"selector":{"app":"frontend","version":"green"}}}'

echo "✅ Successfully promoted GREEN deployments to live!"
