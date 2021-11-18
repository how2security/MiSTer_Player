#!/bin/bash

#======== GLOBAL VARIABLES =========
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/media/fat/linux:/media/fat/Scripts:/media/fat/Scripts/.MiSTer_Player:.

declare -g misterpath="/media/fat"
declare -g mrapmpath="/media/fat/Scripts/.MiSTer_Player"
declare -g musicpath="/media/fat/Music"

declare -g apmpid="${$}"
declare -g apmprocess="$(basename -- ${0})"

declare -g playlist=""
declare -g nextplay=""

### CORES
amarelo="\e[33;1m"
azul="\e[34;1m"
verde="\e[32;1m"
vermelho="\e[31;1m"
fim="\e[m"

#======== LOCAL VARIABLES =========

### APP VARs
gameTimer=60
listenMouse="Yes"
listenKeyboard="Yes"
listenJoy="Yes"
branch="main"

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
	echo -e " start - Start immediately"
	echo -e " skip - Skip to the next play"
	echo -e " stop - Stop immediately"
	echo -e ""
	echo -e " update - Self-Update"
	echo -e " monitor - Monitor APM output"
	echo -e ""
	echo -e " enable -  Enable autoplay"
	echo -e " disable - Disable autoplay"
	echo -e ""
	echo -e "menu - Load menu"
	echo -e ""
	exit 2
}

#======== APM MENU ========

function apmPreMenu(){
	apmBanner
	echo "APM Configuration:"
	if [ -f /etc/init.d/S94misterapm ]; then
		echo "-APM autoplay ENABLED"
	else
		echo "-APM autoplay DISABLED"
	fi
	echo " -Start after ${apmtimeout} sec. idle"
	echo " -Start only on the menu: $menuonly^}"
	echo " -Show each audio for ${gameTimer} sec."
	echo ""
	echo " Press UP to open menu"
	echo " Press Down to start APM"
	echo ""
	echo " Or wait for auto-configuration"
	echo ""

	for i in {10..1}; do
		echo -ne " Updating APM in ${i}...\033[OK\r"
		premenu="Default"
		read -r -s -N 1 -t 1 key
		if [[ "${key}" == "A" ]]; then
			premenu="Menu"
			break
		elif [[ "${key}" == "B" ]]; then
			premenu="Start"
			break
		elif [[ "${key}" == "C" ]]; then
			premenu="Default"
			break
		fi
	done
	apmCommand ${premenu}
}

#======== APM MENU DIALOG ========

function apmMenu() {
	dialog --clear --no-cancel --ascii-lines --no-tags \
	--backtitle "Audio Play Mode" --title "[ Main Menu ]" \
	--menu "Use the arrow keys and enter \nor the d-pad and A button" 0 0 0 \
	Start "Start APM now" \
	Skip "Skip game (ssh only)" \
	Stop "Stop APM (ssh only)" \
	Utility "Update and Monitor" \
	Config "Configure INI Settings" \
	Autoplay "Autoplay Configuration" \
	Cancel "Exit now" 2>"/tmp/.APMmenu"
	menuresponse=$(<"/tmp/.APMmenu")
	clear

	if [ "${apmquiet,,}" == "no" ]; then echo " menuresponse: ${menuresponse}"; fi
	apmCommand ${menuresponse}
}

function apmUtilityMenu() {
	dialog --clear --no-cancel --ascii-lines --no-tags \
	--backtitle "Audio Play Mode" --title "[ Utilities ]" \
	--menu "Select an option" 0 0 0 \
	Update "Update APM to latest" \
	Monitor "Display messages latest" \
	Back "Previous menu" 2>"/tmp/.APMmenu"
	menuresponse=$(<"/tmp/.APMmenu")

	if [ "${apmquit,,}" == "no" ]; then echo " menuresponse: ${menuresponse}"; fi
	apmCommand ${menuresponse}
}

function apmConfigMenu() {
	dialog --clear --ascii-lines --no-cancel \
	--backtitle "Audio Play Modo" --title "[ INI Settings ]" \
	--msgbox "Here you can configure the INI settings for APM.\n\nUse TAB to switch between editing, the OK and Cancel buttons." 0 0

	dialog --clear -ascii-lines \
	--backtitle "Audio Play Modo" --title "[ INI Settings ]" \
	--editbox "${misterpath}/Scripts/MiSTer_APM.ini" 0 0 2> "/tmp/.APMmenu"

	if [ -s "/tmp/.APMmenu" ] && [ "$(diff -wq "/tmp/.APMmenu" "${misterpath}/Scripts/MiSTer_APM.ini")" ]; then
		cp -f "/tmp/.APMmenu" "${misterpath}/Scripts/MiSTer_APM.ini"
		dialog --clear --ascii-lines --no-cancel \
		--backtitle "Audio Play Modo" --title "[ INI Settings ]" \
		--msgbox "Change saved!" 0 0
	fi
	apmCommand menu
}

function apmAutoPlayMenu() {
	dialog --clear --no-cancel --ascii-lines --no-tags \
	--backtitle "Audio Play Mode" --title "[ Configuter Autoplay ]" \
	--menu "Select an options" 0 0 0 \
	Enable "Enable Autoplay" \
	Disable "Disable Autoplay" \
	Back "Previous menu" 2>"/tmp/.APMmenu"
	menuresponse=$(<"/tmp/.APMmenu")

	clear
	if [ "${apmquit,,}" == "no" ]; then echo " menuresponse: ${menuresponse}"; fi
	apmCommand ${menuresponse}
}

#======== APM Parse Command's MENU ========
function apmCommand(){
	
	echo ${@}
	echo ${#}
	echo ${1,,}
	
	if [ ${#} -gt 2 ]; then # Validando se temos mais de 2 parametros
		apmHelp
	elif [ ${#} -eq	0 ]; then # Validando se não temos nenhum paramentro
		apmPreMenu
	else # 
		while [ ${#} -gt 0 ]; do
			case ${1,,} in
				default)
					apmUpdate defaulttb
					break;;
				defaulttb)
					apmUpdate
					apmEnable quickstart
					apmStart
					break
					;;
				start)
					envCheck ${1,,}
					apmStart
					preExit
					break
					;;
				skip | next)
					echo -e "$amarelo[*]$fim Skipping to next play..."
					envCheck ${1,,}
					nextPlay ${nextplay}
					break;;
				stop)
					serialKiller
					echo -e "$azul[@]$fim Thanks for playing!"
					preExit
					break
					;;
				update)
					apmUpdate
					break
					;;
				monitor)
					apmMonitor
					break
					;;
				enable)
					envCheck ${1,,}
					apmEnable
					break
					;;
				disable)
					apmDisable
					break
					;;
				utility)
					apmUtilityMenu
					break
					;;
				autoplay)
					apmAutoPlayMenu
					break
					;;
				config)
					apmConfigMenu
					break
					;;
				menu)
					apmMenu
					break
					;;
				cancel)
					echo -e "$azul[#]$fim It's pitch dark; You are to be eaten by a Grue."
					break
					;;
				back)
					apmMenu
					break
					;;
				help)
					apmHelp
					break
					;;
				*)
					echo -e "$vermelho[-]$fim ERROR: ${1} is unknow."
					echo -e "Try $(basename -- ${0}) help"
					echo -e "or check the Github README."
					break
					;;
			esac
			shift
		done
	fi
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

		if [ -f /media/fat/Scripts/MiSTer_APM.ini ]; then
			echo -e "$amarelo[!]$fim MiSTER APM INI Already exists... SKIPPED!"
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

#======== APM START/STOP ========
function apmStart() { # apm_start (play)
	# Terminate any ither running APM process
	serialKiller

	# If the MCP isn't running we need to start it in monitoring only mode
	if [ -z "$(pidof MiSTer_APM_MCP)" ]; then
		${mrapmpath}/MiSTer_APM_MCP monitornly &
	fi

	# Start APM looping through play
	playList
	loopPlay
}

function serialKiller(){
	# If another attact process is running kill it
	# This can happen if the script is started multiple times
	echo -ne "$azul[-]$fim Stopping other running instances of ${apmprocess}..."
	kill -9 $(pidof -o ${apmpid} ${apmprocess}) &>/dev/null
	kill -9 mpg123 &>/dev/null
	wait $(pidof -o ${apmpid} ${apmprocess}) &>/dev/null
	echo -e "$verde[+]$fim Done!"
}

function playList() {
	echo -e "$amarelo[*]$fim Let stating PLAY!"

	for i in $(ls /media/fat/Music); do
		playlist+=$i" ";
	done
	
	if [ -z playlist ]; then
		echo -e "$vermelho[-]$fim ERROR: FATAL - List of play music is empty. Nothing to do!"
		exit 1
	fi
}

function nextPlay(){
	nextplay="$(echo ${playlist} | xargs shuf --head-count=1 --random-source=/dev/urandom --echo)"
}

function loopPlay(){

	while :; do
	
		counter=${gameTimer}
		
		nextPlay
		loadPlay
		
		while [ ${counter} -gt 0 ]; do
			echo -e "$amarelo[*]$fim Next Validator in ${counter}...\033[OK\r"
			sleep 1
			((counter--))
			
			if [ -s /tmp/.APM_Mouse_Activity ]; then
				if [ "${listenMouse,,}" == "yes" ]; then
					echo -e "$verde[+]$fim Mouse activity detected!"
					exit 
				else
					echo -e "$amarelo[*]$fim Mouse activity ignored!"
					echo "" |> /tmp/.APM_Mouse_Activity
				fi
			fi
			if [ -s /tmp/.APM_Keyboard_Activity ]; then
				if [ "${listenKeyboard,,}" == "yes" ]; then
					echo -e "$verde[+]$fim Keyboard activity detected!"
					exit
				else
					echo -e "$amarelo[*]$fim Keyboard activity ignored!"
					echo "" |> /tmp/.APM_Keyboard_Activity
				fi
			fi
			if [ -s /tmp/.APM_Joystick_Activity ]; then
				if [ "${listenJoy,,}" == "yes" ]; then
					echo -e "$verde[+]$fim Controller activity detected!"
					exit
				else
					echo -e "$amarelo[*]$fim Controller activity ignored!"
					echo "" |> /tmp/.APM_Joystick_Activity
				fi
			fi
		done
	done
}

function loadPlay(){
	echo -ne "$verde[+]$fim Starting now on the "
	echo -e "$(date +%H:%M:%S) - ${1} - ${3}" >> /tmp/APM_PLAY.log
	echo -ne " Loading music in ${i}...\033[OK\r"
	$musicPlayer -q $musicpath/${nextplay}
	sleep 1

	sleep 1
	echo "" |>/tmp/APM_Joystick_Activity
	echo "" |>/tmp/APM_Keyboard_Activity
	echo "" |>/tmp/APM_Mouse_Activity
}

function envCheck() {
	# Check if we're been installed
	if [ ! -f "${mrapmpath}/MiSTer_APM_MCP" ]; then
		echo -e "$vermelho[-]$fim APM required files not found."
		echo -e " Surprised? Check your INI."
		apmUpdate ${1}
		echo -e "$verde[+]$fim Setup complete"
	fi 
}

function preExit() { # pre_exit
	#if [ "${usetty,,}" == "yes" ]; then /etc/init.d/S60tty2oled start; fi
	echo
}

#======== APM ENABLE/DISABLE ========
function apmEnable() {
	echo -ne "$verde[+]$fim Enabling MiSTer APM Autoplay..."
	# Remount root as read-write if read-only so we can add our deamon
	mount | grep "on / .*[(,]ro[,$]" -q && RO_ROOT="true"
	[ "$RO_ROOT" == "true" ] && mount / -o remount,rw 

	# Awaken daemon
	cp -f "${mrapmpath}/MiSTer_APM.init" /etc/init.d/_S94misterapm &>/dev/null
	mv -f /etc/init.d/_S94misterapm /etc/init.d/S94misterapm &>/dev/null
	chmod +x /etc/S94misterapm

	# Remove read-write if we were read-only
	sync
	[ "RO_ROOT" == "true" ] && mount / -o remount,ro 
	sync
	echo -e "$amarelo[*]$fim Done!"

	echo -ne "$verde[+]$fim APM autoplay daemon starting..."

	if [ "${1,,}" == "quickstart" ]; then
		/etc/init.d/S94misterapm &
	else
		/etc/init.d/S94misterapm start &
	fi
	
	echo -e "$amarelo[*]$fim Done!"
	return
}

function apmDisable(){
	echo -ne "$amarelo[*]$fim Disabling APM autoplay..."
	# Clean out existing processes to ensure we can update
	serialKiller
	killall -q -9 S94misterapm
	killall -q -9 MiSTer_Player_MCP
	killall -q -9 MiSTer_APM_Mouse.sh
	killall -q -9 MiSTer_APM_Keyboard.sh
	killall -q -9 xxd
	kill -9 $(ps | grep "inotifywait" | grep "APM_Joy_Change" | cut --field=1 --only-delimited --delimiter=' ')

	mount | grep -q "on / .*[(,]ro[,$]" && RO_ROOT="true"
	[ "RO_ROOT" == "true" ] && mount / -o remount,rw 
	rm -f /etc/S94misterapm > /dev/null 2>&1
	sync
	[ "RO_ROOT" == "true" ] && mount / -o remount,ro 
	sync
	echo -e "$amarelo[*]$fim Done!"
}

#======== APM MONITOR ========
function apmMonitor() {
	PID=$(ps aux | grep MiSTer_APM_on.sh | grep -v grep | awk '{print $1}' | head -n 1)

	if [ $PID ]; then
		echo -ne "$amarelo[*]$fim Attaching MiSTer APM to current shell..."
		THIS=$0
		ARGS=$@
		name=$(basename $THIS)
		quiet="no"
		nopt=""
		shift $((OPTIND-1))
		fds=""
		
		if [ -n "$nopt" ]; then
			for n_f in $nopt; do
			n=${n_f%%:*}
			f=${n_f##*:}
			if [ -n "${n//[0-9]/}" ] || [ -z "$f" ]; then 
				warn "Error parsing descriptor (-n $n_f)"
				exit 1
			fi

			if ! 2>/dev/null : >> $f; then
				warn "Cannot write to (-n $n_f) $f"
				exit 1
			fi
			fds="$fds $n"
			fns[$n]=$f
			done
		fi
		
		if [ -z "$stdout" ] && [ -z "$stderr" ] && [ -z "$stdin" ] && [ -z "$nopt" ]; then
			#second invocation form: dup to my own in/err/out
			[ -e /proc/$$/fd/0 ] &&  stdin=$(readlink /proc/$$/fd/0)
			[ -e /proc/$$/fd/1 ] && stdout=$(readlink /proc/$$/fd/1)
			[ -e /proc/$$/fd/2 ] && stderr=$(readlink /proc/$$/fd/2)
			if [ -z "$stdout" ] && [ -z "$stderr" ] && [ -z "$stdin" ]; then
			warn "Could not determine current standard in/out/err"
			exit 1
			fi
		fi
		
	
		gdb_cmds() {
			local _name=$1
			local _mode=$2
			local _desc=$3
			local _msgs=$4
			local _len
	
			[ -w "/proc/$PID/fd/$_desc" ] || _msgs=""
			if [ -d "/proc/$PID/fd" ] && ! [ -e "/proc/$PID/fd/$_desc" ]; then
			warn "Attempting to remap non-existent fd $n of PID ($PID)"
			fi
	
			[ -z "$_name" ] && return
	
			echo -e "$amarelo[*]$fim set \$fd=open(\"$_name\", $_mode)"
			echo -e "$amarelo[*]$fim set \$xd=dup($_desc)"
			echo -e "$amarelo[*]$fim call dup2(\$fd, $_desc)"
			echo -e "$amarelo[*]$fim call close(\$fd)"

			if  [ $((_mode & 3)) ] && [ -n "$_msgs" ]; then
				_len=$(echo -en "$_msgs" | wc -c)
				echo -e "$amarelo[*]$fim call write(\$xd, \"$_msgs\", $_len)"
			fi

			echo -e "$amarelo[*]$fim call close(\$xd)"
		}
	
		trap '/bin/rm -f $GDBCMD' EXIT
		GDBCMD=$(mktemp /tmp/gdbcmd.XXXX)
		{
			#Linux file flags (from /usr/include/bits/fcntl.sh)
			O_RDONLY=00
			O_WRONLY=01
			O_RDWR=02 
			O_CREAT=0100
			O_APPEND=02000
			echo -e "$amarelo[*]$fim #gdb script generated by running '$0 $ARGS'"
			echo -e "$amarelo[*]$fim attach $PID"
			gdb_cmds "$stdin"  $((O_RDONLY)) 0 "$msg_stdin"
			gdb_cmds "$stdout" $((O_WRONLY|O_CREAT|O_APPEND)) 1 "$msg_stdout"
			gdb_cmds "$stderr" $((O_WRONLY|O_CREAT|O_APPEND)) 2 "$msg_stderr"

			for n in $fds; do
				msg="Descriptor $n of $PID is remapped to ${fns[$n]}\n"
				gdb_cmds ${fns[$n]} $((O_RDWR|O_CREAT|O_APPEND)) $n "$msg"
			done
			#echo "quit"
		} > $GDBCMD
	
		if gdb -batch -n -x $GDBCMD >/dev/null </dev/null; then
			[ "$quiet" != "yes" ] && echo " Done!" >&2
		else
			warn " Failed!"
		fi
		
		#cp $GDBCMD /tmp/gdbcmd
		rm -f $GDBCMD
	else
		echo -e "$amarelo[*]$fim Couldn't detect MiSTer_SAM_on.sh running"
	fi
}

#======== APM MAIN FUNCTION ========

function main(){
	apmBanner
	apmCommand ${@}
	preExit
	exit 0
}
main
