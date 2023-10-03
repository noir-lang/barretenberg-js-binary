#!/bin/bash

# Check if npm is installed
if ! which npm &>/dev/null; then
    echo "npm is not installed!" >&2
    exit 1
fi

# Check if node is installed
if ! which node &>/dev/null; then
    echo "node is not installed!" >&2
    exit 1
fi

# Check if node version is 18+
NODE_VERSION=$(node -v | tr -d 'v')
NODE_MAJOR_VERSION=${NODE_VERSION%%.*}
if [ $NODE_MAJOR_VERSION -lt 18 ]; then
    echo "You need Node.js version 18 or higher. Currently installed: $NODE_VERSION" >&2
    exit 1
fi

# Name of the npm binary to install
BINARY_NAME="@aztec/bb.js"
DESIRED_BINARY_VERSION=${DESIRED_BINARY_VERSION:-"0.7.3"} # Default to 0.7.3 if not set

# Check if the binary is installed and verify its version
if which $BINARY_NAME &>/dev/null; then
    INSTALLED_BINARY_VERSION=$($BINARY_NAME --version)
    if [ "$INSTALLED_BINARY_VERSION" != "$DESIRED_BINARY_VERSION" ]; then
        echo "Incorrect version of $BINARY_NAME installed. Expected $DESIRED_BINARY_VERSION but found $INSTALLED_BINARY_VERSION. Installing correct version..." >&2
        npm install -g "$BINARY_NAME@$DESIRED_BINARY_VERSION" >&2
    fi
else
    echo "Installing $BINARY_NAME version $DESIRED_BINARY_VERSION..." >&2
    npm install -g "$BINARY_NAME@$DESIRED_BINARY_VERSION" >&2
fi

if [ $? -ne 0 ]; then
    echo "Error installing or updating $BINARY_NAME!" >&2
    exit 1
fi

# Execute the binary with any arguments passed to the script
# ie this script is just a shim to run the binary
bb.js "$@"
