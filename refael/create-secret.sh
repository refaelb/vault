secret_name=test-vault
namespace=test-vault
secret_key="password"
secret_value="rootroot"
objectName="db-password"


kubectl -n vault exec  vault-0 -c "vault kv put $namespace/$secret_name $secret_key=$secret_value"

kubectl -n vault exec  vault-0 -c "vault policy write internal-app - <<EOF
path $namespace"/data/"$secret_name {
  capabilities = ["read"]
}
EOF"

kubectl -n vault exec  vault-0 -c "vault write auth/kubernetes/role/$secret_name \
    bound_service_account_names=$namespace-sa \
    bound_service_account_namespaces=$namespace \
    policies=internal-app \
    ttl=20m"


kubectl create serviceaccount $namespace-sa -n $namespace

##secret##
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: vault-$secret_name
spec:
  provider: vault
  secretObjects:
  - data:
    - key: $secret_key
      objectName: $objectName
    secretName: $secret_name
    type: Opaque
  parameters:
    vaultAddress: "http://vault.vault:8200"
    roleName: $secret_name
    objects: |
      - objectName: $objectName
        secretPath: "$namespace/data/$secret_name"
        secretKey: $secret_key

##