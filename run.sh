#!/bin/bash

[[ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]] && {
  gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
}

if [[ $# -eq 0 ]]; then
  exec /bin/bash
else
  exec "$@"
fi
