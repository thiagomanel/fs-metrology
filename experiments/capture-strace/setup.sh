#!/bin/bash
# Any setup required by the experiment goes here. Things like installing
# packages, allocating resources or deploying software on remote
# infrastructure can be implemented here.
set -e

# add commands here:

if [ -n "$REMOTE" ]; then
    # setup a remote env
    setup/remote.sh
else
    # setup a local env
    setup/local.sh $(realpath environment.conf)
fi

exit 0
