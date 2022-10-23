curl \
    -H "X-Vault-Token: f3b09679-3001-009d-2b80-9c306ab81aa6" \
    -H "X-Vault-Request: true" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{"value":"bar"}' \
    http://127.0.0.1:8200/v1/secret/baz
