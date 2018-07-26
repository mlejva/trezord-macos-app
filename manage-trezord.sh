#!/bin/sh

#  ShellScript.command.sh
#  trezor-daemon-macos-app
#
#  Created by Vašek Mlejnský on 12/07/2018.
#  Copyright © 2018 Vaclav Mlejnsky. All rights reserved.


# No need for trap since the process is terminated from AppDelegate.swift and trezord is killed

killall trezord-go # In case another instance is running
# Daemon is bundled within the .app
DAEMON_PATH="./trezor-daemon-macos-app.app/Contents/Resources/trezord-go"
$DAEMON_PATH
