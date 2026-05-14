#!/bin/bash
/opt/openvscode-server/bin/openvscode-server \
  --host 0.0.0.0 \
  --port 8080 \
  --without-connection-token \
  --user-data-dir /workspace/.vscode \
  --extensions-dir /workspace/.vscode/extensions \
  /workspace
