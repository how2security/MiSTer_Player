#!/bin/bash

#======== GLOBAL VARIABLES =========
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/media/fat/linux:/media/fat/Scripts:/media/fat/Scripts/.MiSTer_Player:.

declare -g misterpath="/media/fat"
declare -g mrapmpath="/media/fat/Scripts/.MiSTer_Player"
declare -g musicpath="/media/fat/Music"

declare -g playlist=""
declare -g nextplay=""

### CORES
amarelo="\e[33;1m"
azul="\e[34;1m"
verde="\e[32;1m"
vermelho="\e[31;1m"
fim="\e[m"

#======== LOCAL VARIABLES =========

### BIN
musicPlayer=`which mpg123`
randPlay="yes"
volPlay=70

#========= PARSE INI =========
if [ -f "${misterpath}/Scripts/MiSTer_APM.ini" ]; then
	source "${misterpath}/Scripts/MiSTer_APM.ini"
fi
#========= MATRIZ PLAYLIST =========


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
	echo -e " MiSTer_APM_Unistall.sh - Unistall APM"
	echo -e ""
	echo -e "Another scripts futire use"
	exit 2
}

#======== APM START/STOP ========
function apmStart() { # apm_start (play)
	# Terminate any ither running APM process
	serialKiller

	# Start APM looping through play
	loadPlay
}

function serialKiller(){
	# If another attact process is running kill it
	# This can happen if the script is started multiple times
	echo -ne "$azul[-]$fim Stopping other running instances of ${apmprocess}..."
	killall -9 $musicPlayer &>/dev/null
	killall -9 MiSTer_APM.on.sh &>/dev/null
	killall -9 MiSTer_APM.off.sh &>/dev/null
	killall -9 MiSTer_APM.Update.sh &>/dev/null
	
	echo -e "$verde[+]$fim Done!"
}

function loadPlay(){
	echo -ne "$verde[+]$fim Starting now on the "
	echo -e "$(date +%H:%M:%S) - ${1} - ${3}" >> /tmp/APM_PLAY.log
	echo -ne " Loading music in ${i}...\033[OK\r"
	$musicPlayer -q -Z $musicpath/* 2>&1 &
	sleep 1
}

#======== APM MAIN FUNCTION ========

function main(){
	apmBanner
	apmStart
	exit 0
}
main
