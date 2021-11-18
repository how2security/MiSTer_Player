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
	echo -e " MiSTer_APM_Update.sh - Install and Update APM"
	echo -e " MiSTer_APM_on.sh - Starting play music in /media/fat/Music folder"
	echo -e " MiSTer_APM_off.sh - Stopping play music"
	echo -e " MiSTer_APM_Unistall.sh - Uninstall APM"
	echo -e ""
	echo -e "Another scripts futire use"
	exit 2
}

#======== APM UPDATE ========
function apmUnistall() {
	
	echo -e "$vermelho[-]$fim Unistall APM =["
	rm -rf ${mrapmpath} &>/dev/null
	rm -rf /media/fat/Scripts/MiSTer_APM_Update.sh &>/dev/null
	rm -rf /media/fat/Scripts/MiSTer_APM_on.sh &>/dev/null
	rm -rf /media/fat/Scripts/MiSTer_APM_off.sh &>/dev/null
	rm -rf /media/fat/Scripts/MiSTer_APM.ini &>/dev/null
	rm -rf /media/fat/Scripts/MiSTer_APM_Uninstall.sh &>/dev/null
	echo -e "$azul[+]$fim Unistall complete!"
}

#======== APM MAIN FUNCTION ========

function main(){
	apmBanner
	apmUnistall
	exit 0
}
main
