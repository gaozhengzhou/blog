#!/bin/bash
if [ -z "$GIT_KEYFILE" ]; then
  # if GIT_KEYFILE is not specified, run ssh using default keyfile
  ssh "$@"
else
  ssh -i "$GIT_KEYFILE" "$@"
fi