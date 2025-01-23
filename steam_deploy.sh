#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

steamdir=${STEAM_HOME:-$HOME/Steam}
# this is relative to the action
contentroot=$(pwd)/$rootPath

if [ -n "$steam_totp" ]; then
  echo ""
  echo "#################################"
  echo "#     Using SteamGuard TOTP     #"
  echo "#################################"
  echo ""
else
  if [ ! -n "$configVdf" ]; then
    echo "Config VDF input is missing or incomplete! Cannot proceed."
    exit 1
  fi

  steam_totp="INVALID"

  echo ""
  echo "#################################"
  echo "#    Copying SteamGuard Files   #"
  echo "#################################"
  echo ""

  echo "Steam is installed in: $steamdir"

  mkdir -p "$steamdir/config"

  echo "Copying $steamdir/config/config.vdf..."
  echo "$configVdf" | base64 -d > "$steamdir/config/config.vdf"
  chmod 777 "$steamdir/config/config.vdf"

  echo "Finished Copying SteamGuard Files!"
  echo ""
fi

echo ""
echo "#################################"
echo "#        Test login             #"
echo "#################################"
echo ""

steamcmd +set_steam_guard_code "$steam_totp" +login "$steam_username" +quit;

ret=$?
if [ $ret -eq 0 ]; then
    echo ""
    echo "#################################"
    echo "#        Successful login       #"
    echo "#################################"
    echo ""
else
      echo ""
      echo "#################################"
      echo "#        FAILED login           #"
      echo "#################################"
      echo ""
      echo "Exit code: $ret"

      exit $ret
fi

exit 1
