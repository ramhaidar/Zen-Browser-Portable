#!/bin/bash
APP_DIR="$(dirname "$0")/../App/zen"
DATA_DIR="$(dirname "$0")/../Data"
"$APP_DIR/zen" --profile "$DATA_DIR/profile" --no-remote &>/dev/null &
