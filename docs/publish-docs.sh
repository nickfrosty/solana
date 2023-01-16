#!/usr/bin/env bash

set -e

if [[ -d .vercel ]]; then
  rm -r .vercel
fi

CONFIG_FILE=vercel.json

if [[ -n $CI_TAG ]]; then
  PROJECT_NAME=docs-solana-com
else
  eval "$(../ci/channel-info.sh)"
  case $CHANNEL in
  edge)
    PROJECT_NAME=edge-docs-solana-com
    ;;
  beta)
    PROJECT_NAME=beta-docs-solana-com
    ;;
  *)
    PROJECT_NAME=docs
    ;;
  esac
fi

cat > "$CONFIG_FILE" <<EOF
{
  "name": "$PROJECT_NAME",
  "scope": "solana-labs",
  "redirects": [
    { "source": "/apps", "destination": "/developers" },
    { "source": "/developing/programming-model/overview", "destination": "/developers" },
    { "source": "/apps/backwards-compatibility", "destination": "/developing/backwards-compatibility" },
    { "source": "/apps/break", "destination": "/developing/on-chain-programs/examples" },
    { "source": "/apps/builtins", "destination": "/developing/runtime-facilities/programs" },
    { "source": "/apps/drones", "destination": "/developing/on-chain-programs/examples" },
    { "source": "/apps/hello-world", "destination": "/developing/on-chain-programs/examples" },
    { "source": "/apps/javascript-api", "destination": "/developing/clients/javascript-api" },
    { "source": "/apps/jsonrpc-api", "destination": "/developing/clients/jsonrpc-api" },
    { "source": "/apps/programming-faq", "destination": "/developing/on-chain-programs/faq" },
    { "source": "/apps/rent", "destination": "/learn/economics/rent" },
    { "source": "/apps/sysvars", "destination": "/developing/runtime-facilities/sysvars" },
    { "source": "/apps/webwallet", "destination": "/learn/basics/wallets" },
    { "source": "/introduction", "destination": "/learn/intro" },
    { "source": "/history", "destination": "/learn/intro/history" },
    { "source": "/transaction_fees", "destination": "/learn/economics/transaction_fees" },
    { "source": "/economics_overview", "destination": "/learn/economics" },
    { "source": "/wallet-guide", "destination": "/learn/basics/wallets" },
    { "source": "/storage_rent_economics", "destination": "/learn/economics/rent" },
    { "source": "/developing/intro/rent", "destination": "/learn/economics/rent" },
    { "source": "/implemented-proposals/cross-program-invocation", "destination": "/developing/programming-model/calling-between-programs" },
    { "source": "/implemented-proposals/program-derived-addresses", "destination": "/developing/programming-model/calling-between-programs#program-derived-addresses" },
    { "source": "/implemented-proposals/secp256k1_instruction", "destination": "/developing/runtime-facilities/programs#secp256k1-program" }
  ]
}
EOF

[[ -n $VERCEL_TOKEN ]] || {
  echo "VERCEL_TOKEN is undefined.  Needed for Vercel authentication."
  exit 1
}
vercel deploy . --local-config="$CONFIG_FILE" --confirm --token "$VERCEL_TOKEN" --prod
