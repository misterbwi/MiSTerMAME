#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Copyright 2018-2019 Alessandro "Locutus73" Miele

# You can download the latest version of this script from:
# https://github.com/RetroDriven/MiSTer_UnofficialCores

: '
###### Disclaimer / Legal Information ######
By downloading and using this Script you are agreeing to the following:

* You are responsible for checking your local laws regarding the use of the ROMs that this Script downloads.
* You are authorized/licensed to own/use the ROMs associated with this Script.
* You will not distribute any of these files without the appropriate permissions.
* You own the original Arcade PCB for ROM file that you download.
* I take no responsibility for any data loss or anything, use the script at your own risk.
'

# v1.0 - Changed original Script from Locutus73 as needed

#=========   USER OPTIONS   =========

#Base directory for all script’s tasks, "/media/fat" for SD root, "/media/usb0" for USB drive root.
#BASE_PATH="/media/fat"
BASE_PATH="/media/fat"

#Directory for Mame Zips
MAME_PATH=$BASE_PATH/"Arcade/Mame"

#========= CODE STARTS HERE =========

echo
echo "*** NEWS: RetroDriven.com - Launching Soon! ***"
echo
#sleep 3
echo "*** RetroDriven Core Updater - A Festivus for the rest of Us! ***" 
echo
#sleep 3

ALLOW_INSECURE_SSL="true"
CURL_RETRY="--connect-timeout 15 --max-time 120 --retry 3 --retry-delay 5"

ORIGINAL_SCRIPT_PATH="$0"
if [ "$ORIGINAL_SCRIPT_PATH" == "bash" ]
then
	ORIGINAL_SCRIPT_PATH=$(ps | grep "^ *$PPID " | grep -o "[^ ]*$")
fi
INI_PATH=${ORIGINAL_SCRIPT_PATH%.*}.ini
if [ -f $INI_PATH ]
then
	eval "$(cat $INI_PATH | tr -d '\r')"
fi

if [ -d "${BASE_PATH}/${OLD_SCRIPTS_PATH}" ] && [ ! -d "${BASE_PATH}/${SCRIPTS_PATH}" ]
then
	mv "${BASE_PATH}/${OLD_SCRIPTS_PATH}" "${BASE_PATH}/${SCRIPTS_PATH}"
	echo "Moved"
	echo "${BASE_PATH}/${OLD_SCRIPTS_PATH}"
	echo "to"
	echo "${BASE_PATH}/${SCRIPTS_PATH}"
	echo "please relaunch the script."
	exit 3
fi

SSL_SECURITY_OPTION=""
curl $CURL_RETRY -q https://retrodriven.com &>/dev/null
case $? in
	0)
		;;
	60)
		if [ "$ALLOW_INSECURE_SSL" == "true" ]
		then
			SSL_SECURITY_OPTION="--insecure"
		else
			echo "CA certificates need"
			echo "to be fixed for"
			echo "using SSL certificate"
			echo "verification."
			echo "Please fix them i.e."
			echo "using security_fixes.sh"
			exit 2
		fi
		;;
	*)
		echo "No Internet connection"
		exit 1
		;;
esac

#Make Directories if needed
mkdir -p $MAME_PATH
mkdir -p $MRA_PATH

#Mame Zip Downloading
echo "Checking MAME Zips"
echo
sleep 3
for file_mame in $(curl $CURL_RETRY $SSL_SECURITY_OPTION -s https://mister.retrodriven.com/MAME/Mame/ |
                  grep href |
                  sed 's/.*href="//' |
                  sed 's/".*//' |
                  grep '^[a-zA-Z0-9].*'); do
	cd $MAME_PATH 
	if [ -e "$MAME_PATH/$file_mame" ]; then
	    echo "Skipping: $file_mame" >&2
	else
	    echo "Downloading: $file_mame"
	    curl $CURL_RETRY $SSL_SECURITY_OPTION -s -O https://mister.retrodriven.com/MAME/Mame/$file_mame
	fi
done
echo

echo
echo "*** All MAME Zips are up to date! ***"
#echo
#echo "** Please visit RetroDriven.com for all of your MiSTer and Retro News and Updates! ***"
echo