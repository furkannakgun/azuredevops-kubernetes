#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo "error: missing AZP_TOKEN environment variable"
    exit 1
  fi
  AZP_TOKEN_FILE=/azp/.token
  echo -n $AZP_TOKEN >"$AZP_TOKEN_FILE"
fi
unset AZP_TOKEN

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

cleanup() {
  ./bin/Agent.Listener remove --unattended \
    --auth PAT \
    --token $(cat "$AZP_TOKEN_FILE")
}

trap 'cleanup; exit 0' INT EXIT

./bin/Agent.Listener configure --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $(cat "$AZP_TOKEN_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-_work}" \
  --replace & wait $!

./bin/Agent.Listener run & wait $!
