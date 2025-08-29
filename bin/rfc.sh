#!/bin/bash

[[ ! -d /usr/share/doc/rfc ]] && echo "rfc db is not installed." && exit;

pushd /usr/share/doc/rfc/
nvim
popd
