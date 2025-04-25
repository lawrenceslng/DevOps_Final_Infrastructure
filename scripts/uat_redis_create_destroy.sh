aws elasticache create-replication-group \
    --replication-group-id my-uat-valkey \
    --replication-group-description "Temporary UAT Valkey" \
    --engine valkey \
    --engine-version 7.2 \
    --cache-node-type cache.t3.micro \
    --num-node-groups 1 \
    --replicas-per-node-group 0 \
    --transit-encryption-enabled \
    --at-rest-encryption-enabled \
    --security-group-ids sg-xxxxxxxx \
    --cache-subnet-group-name my-valkey-subnet-group \
    --region us-east-1

aws elasticache delete-replication-group \
    --replication-group-id my-uat-valkey \
    --retain-primary-cluster false
