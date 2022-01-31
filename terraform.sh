#!/bin/bash
CURRENT_DIR=$(pwd)
export GOOGLE_PROJECT=phu-le-it
export GOOGLE_APPLICATION_CREDENTIALS="${CURRENT_DIR}/service_account.json"
terraform $@
