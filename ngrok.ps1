# Reverse Windows RDP for GitHub Actions
# This YAML establishes the "build" workflow where we will execute all required scripts
# During the process, it should get stuck at the last step where it creates a new tunnel on ngrok.

name: Windows
on: [push]

jobs:
  build:
    runs-on: self-hosted
    steps:
    - uses: actions/checkout@v2
    - name: Preparing environment...
      env:
        NGROK_AUTH_TOKEN: 2kwqb5Jgzh6dF4TxPrhwjBk5mbb_3rRuVNC7Ztq2SDS9fV4w1
        RDP_PASSWORD: 1
      run: ./configure.ps1
    - name: Creating tunnel with ngrok...
      run: ./ngrok/ngrok tcp 3389
