name: CI

on:
  push:
  workflow_dispatch:

jobs:
  build:
    runs-on: windows-latest
    steps:
    - name: Download ngrok
      run: Invoke-WebRequest https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-v3-stable-windows-amd64.zip -OutFile ngrok.zip
    - name: Extract ngrok
      run: Expand-Archive ngrok.zip
    - name: Authenticate with ngrok
      run: .\ngrok\ngrok.exe authtoken $Env:NGROK_AUTH_TOKEN
      env:
        NGROK_AUTH_TOKEN: ${{ secrets.NGROK_AUTH_TOKEN }}
    - name: Enable Remote Desktop
      run: |
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
        Set-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "P@ssw0rd!" -Force)
      name: one drive
      run:  Invoke-webrequest https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=us -outfile onedrive.exe
            $command = "C:\Users\runneradmin\Downloads\onedrive.exe"
            Invoke-Expression $command
    - name: Create ngrok tunnel to remote desktop
      run: .\ngrok\ngrok.exe tcp 3389
