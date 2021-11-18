#!/bin/bash

#======== GLOBAL VARIABLES =========
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/media/fat/linux:/media/fat/Scripts:/media/fat/Scripts/.MiSTer_Player:.

declare -g misterpath="/media/fat"
declare -g mrapmpath="/media/fat/Scripts/.MiSTer_Player"
declare -g musicpath="/media/fat/Music"

### CORES
amarelo="\e[33;1m"
azul="\e[34;1m"
verde="\e[32;1m"
vermelho="\e[31;1m"
fim="\e[m"

branch="main"

#======== APM DEFAULTS FUNCTIONS ========

function apmBanner(){
	echo "#  2▄222222222▄22▄▄▄▄▄▄▄▄▄▄▄22▄222222222▄22▄▄▄▄▄▄▄▄▄▄▄22▄▄▄▄▄▄▄▄▄▄▄22▄▄▄▄▄▄▄▄▄▄▄22▄▄▄▄▄▄▄▄▄▄▄2"
	echo "#  ▐░▌2222222▐░▌▐░░░░░░░░░░░▌▐░▌2222222▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌"
	echo "#  ▐░▌2222222▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌2222222▐░▌2▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀2▐░█▀▀▀▀▀▀▀▀▀2▐░█▀▀▀▀▀▀▀▀▀2"
	echo "#  ▐░▌2222222▐░▌▐░▌2222222▐░▌▐░▌2222222▐░▌2222222222▐░▌▐░▌2222222222▐░▌2222222222▐░▌2222222222"
	echo "#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌2222222▐░▌▐░▌222▄222▐░▌2▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄2▐░█▄▄▄▄▄▄▄▄▄2▐░▌2222222222"
	echo "#  ▐░░░░░░░░░░░▌▐░▌2222222▐░▌▐░▌22▐░▌22▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌2222222222"
	echo "#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌2222222▐░▌▐░▌2▐░▌░▌2▐░▌▐░█▀▀▀▀▀▀▀▀▀22▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀2▐░▌2222222222"
	echo "#  ▐░▌2222222▐░▌▐░▌2222222▐░▌▐░▌▐░▌2▐░▌▐░▌▐░▌22222222222222222222▐░▌▐░▌2222222222▐░▌2222222222"
	echo "#  ▐░▌2222222▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌░▌222▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄22▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄2▐░█▄▄▄▄▄▄▄▄▄2"
	echo "#  ▐░▌2222222▐░▌▐░░░░░░░░░░░▌▐░░▌22222▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌"
	echo "#  2▀222222222▀22▀▀▀▀▀▀▀▀▀▀▀22▀▀2222222▀▀22▀▀▀▀▀▀▀▀▀▀▀22▀▀▀▀▀▀▀▀▀▀▀22▀▀▀▀▀▀▀▀▀▀▀22▀▀▀▀▀▀▀▀▀▀▀2"
	echo "#  2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222"
	echo -e "$azul##############################################################################################$fim"
	echo -e "$azul# By PandoraFighter                                                                          #$fim"
	echo -e "$azul#                                                                                            #$fim"
	echo -e "$azul# MiSTER Audio Player Mode Version 1.0 - How2Sec Lab                                         #$fim"
	echo -e "$azul#                                                                                            #$fim"
	echo -e "$azul# Created: 17/11/2021  Updated: 17/11/2021                                                   #$fim"
	echo -e "$azul##############################################################################################$fim"

	echo -e "\012"
}

function apmHelp()
{
	apmBanner
	echo -e " MiSTer_APM_Update - Install and Update APM"
	echo -e " MiSTer_APM_on.sh - Starting play music in /media/fat/Music folder"
	echo -e " MiSTer_APM_off.sh - Stopping play music"
	echo -e " MiSTer_APM_Unistall.sh - Stopping play music"
	echo -e ""
	echo -e "Another scripts futire use"
	exit 2
}

#======== APM UPDATE ========
function apmUpdate() { # apm_update (next command)
	# Ensure the MiSTer Player data directory exists
	mkdir --parents "${mrapmpath}" &>/dev/null

	# Prep curl
	curl_check

	if [ ! "$(dirname -- ${0})" == "/tmp" ]; then
		# Warn if using non-default branch for update
		if [ ! "${branch}" == "main" ]; then
			apmBanner
		fi

		# Download the newest MiSTer_APM_on.sh to /tmp
		getAPMDownload MiSTer_APM_on.sh /tmp
		if [ -f /tmp/MiSTer_APM_on.sh ]; then
			if [ ${1} ]; then
				echo -e "$azul[+]$fim Continuing setup with latest"
				echo -e "$azul[+]$fim  MiSTer_APM_on.sh..."
				/tmp/MiSTer_APM_on.sh ${1}
				exit 0
			fi
		else
			# /tmp/MiSTer_APM_on.sh isn't there!
			echo -e "$vermelho[-]$fim APM update FAILED"
			echo " No Internet?"
			exit 1
		fi
	else # We're running from /tmp - download dependencies and procced
		cp --force "/tmp/MiSTer_APM_on.sh" "/media/fat/Scripts/MiSTer_APM_on.sh"
		getAPMDownload .MiSTer_Player/MiSTer_APM_init
		getAPMDownload .MiSTer_Player/MiSTer_APM_MCP
		getAPMDownload .MiSTer_Player/MiSTer_APM_Joy.py 
		getAPMDownload .MiSTer_Player/MiSTer_APM_Keyboard.sh 
		getAPMDownload .MiSTer_Player/MiSTer_APM_Mouse.sh 
		getAPMDownload MiSTer_APM_off.sh /media/fat/Scripts
		getAPMDownload MiSTer_APM_Update.sh /media/fat/Scripts
		getAPMDownload MiSTer_APM_Unistall.sh /media/fat/Scripts

		if [ -f /media/fat/Scripts/MiSTer_APM.ini ]; then
			echo -e "$amarelo[!]$fim MiSTer APM INI Already exists... SKIPPED!"
		else
			getAPMDownload MiSTer_APM.ini /media/fat/Scripts
		fi
	fi
	echo -e "$azul[+]$fim Update complete!"
	return
}

function curl_check() {
	ALLOW_INSECURE_SSL="true"
	SSL_SECURITY_OPTION="true"

	curl --connect-timeout 15 --max-time 600 --retry 3 --retry-delay 5 \
	--silent --show-error "https://github.com" > /dev/null 2>&1

	case $? in
		0)
			;;
		60)
			if [[ "${ALLOW_INSECURE_SSL}" == "true" ]]; then
				declare -g SSL_SECURITY_OPTION="--insecure"
			else
				echo "CA certificates need"
				echo "to be fixed for"
				echo "using SSL certificate"
				echo "Please fix them i.e."
				echo "using security_fixes.sh"
				exit 2
			fi
			;;
		*)
			echo -e "$vermelho[-]$fim No Internet connection"
			;;
	esac

	set -e
}

function getAPMDownload() { # get_apmstuff file (path)
	if [ -z "${1}" ]; then
		return 1
	fi

	filepath="${2}"
	if [ -z "${filepath}" ]; then
		filepath="${mrapmpath}"
	fi

	REPOSITORY_URL="https://github.com/how2security/MiSTer_Player"
	echo -ne " Downloading from ${REPOSITORY_URL}/blob/${branch}/${1} to ${filepath}/..."
	curl_download "/tmp/${1##*/}" "${REPOSITORY_URL}/blob/${branch}/${1}?raw=true"

	if [ ! "${filepath}" == "/tmp" ]; then
		mv --force "/tmp/${1##*/}" "${filepath}/${1##*/}"
	fi

	if [ "${1##*.}" == "sh" ]; then
		chmod +x "${filepath}/${1##*/}"
	fi

	echo -e "$verde[+]$fim Done!"
}

function curl_download() {
	curl \
	--connect-timeout 15 --max-time 600 --retry 3 --retry-delay 5 --silent --show-error \
	${SSL_SECURITY_OPTION} \
	--fail \
	--location \
	-o "${1}" \
	"${2}"
}

#======== APM MAIN FUNCTION ========

function main(){
	apmBanner
	apmUpdate
	exit 0
}
main
