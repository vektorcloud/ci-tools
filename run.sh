#!/bin/bash

[[ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]] && {
  gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
}

exec /bin/bash $@
