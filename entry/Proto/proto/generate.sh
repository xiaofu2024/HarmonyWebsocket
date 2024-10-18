#!/usr/bin/env bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}"
if ([ -h "${SCRIPT_PATH}" ]); then
  while([ -h "${SCRIPT_PATH}" ]); do cd "$(dirname "$SCRIPT_PATH")";
  SCRIPT_PATH=$(readlink "${SCRIPT_PATH}"); done
fi
cd "$(dirname ${SCRIPT_PATH})" > /dev/null
cd .. > /dev/null
dir=$(pwd);
popd  > /dev/null

source $dir/proto/_proto_env.sh

e docker exec -t wcs_gentool bash ../../proto_gen.sh || exit $?

# e go build -o main ../service/core || exit $?
echo "all done"
