#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/media/fat/linux:/media/fat/Scripts:/media/fat/Scripts/.MiSTer_Player:.

#======== GLOBAL VARIABLES =========

declare -g mrapmpath="/media/fat/Scripts/.MiSTer_Player"
declare -g misterpath="/media/fat"

declare -g apmpid="${$}"
declare -g apmprocess="$(basename -- ${0})"

#======== DEBUG VARIABLES ========

apmquiet="Yes"
apmdebug="No"
apmtrace="No"

#======== LOCAL VARIABLES ========

gameTimer=120
listenMouse="Yes"
listenKeyboard="Yes"
listenJoy="Yes"

playlist="Music,MP3,Audio,OST,music,mp3,audio,ost"
branch="main"

#======== AUDIO PATHS ========

musicPlay="/media/fat/Musics"
mp3Play="/media/fat/MP3"
audioPlay="/media/fat/Audio"
ostPlay="/media/fat/OST"

#========= PARSE INI =========
if [ -f "${misterpath}/Scripts/MiSTer_APM.ini" ]; then
	source "${misterpath}/Scripts/MiSTer_APM.ini"
fi

# Setup folders audio
playlist="$(echo ${playlist} | tr ',' ' ')"

#======== PLAY CONFIG ========
function init_data() {
	declare -gA PLAY_PRETTY=( \
		["music"]="Folde Music" \
		["mp3"]="Folder MP3" \
		["audio"]="Folder Audio" \
		["osd"]="Folder OSD" \
	)
}

#======== APM MENU ========

# PRE MENU

function apm_premenu() {
	echo "+------------------------+"
	echo "| MiSTer Audio Play Mode |"
	echo "+------------------------+"
	echo "APM Configuration:"
	if [ -f /etc/init.d/S94misterapm ]; then
		echo "-APM autoplay ENABLED"
	else
		echo "-APM autoplay DISABLED"
	fi
	echo "-Start after ${apmtimeout} sec. idle"
	echo "-Start only on the menu: $menuonly^}"
	echo "-Show each audio for ${gameTimer} sec."
	echo ""
	echo "Press UP to open menu"
	echo "Press Down to start APM"
	echo ""
	echo "Or wait for"
	echo "auto-configuration"
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
	parse_cmd ${premenu}
}

#======== APM MENU ========
function apm_menu() {
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

	if [ "${apmquit,,}" == "no" ]; then echo " menuresponse: ${menuresponse}"; fi
	parse_cmd ${menuresponse}
}

#Single "Games from only one core" \ <- colocar essa linha no menu principal do APM
#function apm_singlemenu() {
#	declare -a menulist=()
#	for core in 
#}

#======== APM Utility MENU ========
# 

function apm_utilitymenu() {
	dialog --clear --no-cancel --ascii-lines --no-tags \
	--backtitle "Audio Play Mode" --title "[ Utilities ]" \
	--menu "Select an option" 0 0 0 \
	Update "Update APM to latest" \
	Monitor "Display messages latest" \
	Back "Previous menu" 2>"/tmp/.APMmenu"
	menuresponse=$(<"/tmp/.APMmenu")

	if [ "${apmquit,,}" == "no" ]; then echo " menuresponse: ${menuresponse}"; fi
	parse_cmd ${menuresponse}
}

#======== APM Autoplay MENU ========
# Habilita | Desabilita o Auto-Play

function apm_autoplaymenu() {
	dialog --clear --no-cancel --ascii-lines --no-tags \
	--backtitle "Audio Play Mode" --title "[ Configuter Autoplay ]" \
	--menu "Select an options" 0 0 0 \
	Enable "Enable Autoplay" \
	Disable "Disable Autoplay" \
	Back "Previous menu" 2>"/tmp/.APMmenu"
	menuresponse=$(<"/tmp/.APMmenu")

	clear
	if [ "${apmquit,,}" == "no" ]; then echo " menuresponse: ${menuresponse}"; fi
	parse_cmd ${menuresponse}
}

#======== APM Config MENU ========
# Abre o arquivo de inicialização (INI) para configurar direto no no dialog

function apm_configmenu() {
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
	parse_cmd menu
}

#======== APM FUNCTIONS ========
# Funções de manipulação do script

#======== APM serialKiller FUNCTIONS ========
# Termina todos os processos atravez da função serialKiller()

function serialKiller(){
	# If another attact process is running kill it
	# This can happen if the script is started multiple times
	echo -n " Stopping other running instances of ${apmprocess}..."
	kill -9 $(pidof -o ${apmpid} ${apmprocess}) &>/dev/null
	wait $(pidof -o ${apmpid} ${apmprocess}) &>/dev/null
	echo " Done!"
}

#======== APM loopPlay FUNCTIONS ========
# Inicia o Play atravez da função loopPlay() e monitora
# se houve interação com mouse, teclado ou joyustick
function loopPlay() {
	echo " Let stating PLAY!"

	# Reset log for this session
	echo "" |> /tmp/MiSTer_APM.log

	while :; do
		counter=${gameTimer}

		next_play ${1}
		while [ ${counter} -gt 0 ]; do
			echo -ne " Next play in ${counter}...\033[OK\r"
			sleep 1
			((counter--))

			if [ -s /tmp/.APM_Mouse_Activity ]; then
				if [ "${listenMouse,,}" == "yes" ]; then
					echo " Mouse activity detected!"
					exit 
				else
					echo " Mouse activity ignored!"
					echo "" |> /tmp/.APM_Mouse_Activity
				fi
			fi
			if [ -s /tmp/.APM_Keyboard_Activity ]; then
				if [ "${listenKeyboard,,}" == "yes" ]; then
					echo " Keyboard activity detected!"
					exit
				else
					echo " Keyboard activity ignored!"
					echo "" |> /tmp/.APM_Keyboard_Activity
				fi
			fi
			if [ -s /tmp/.APM_Joystick_Activity ]; then
				if [ "${listenJoy,,}" == "yes" ]; then
					echo " Controller activity detected!"
					exit
				else
					echo " Controller activity ignored!"
					echo "" |> /tmp/.APM_Joystick_Activity
				fi
			fi
		done
	done
}

#======== APM Start MENU ========
# Termina todos os processos atravez da função serialKiller()
# e depois
# Inicia o Play atravez da função loopPlay() e monitora
# se houve interação com mouse, teclado ou joyustick

function apm_start() { # apm_start (play)
	# Terminate any ither running APM process
	serialKiller

	# If the MCP isn't running we need to start it in monitoring only mode
	if [ -z "$(pidof MiSTer_APM_MCP)" ]; then
		${mrapmpath}/MiSTer_APM_MCP monitonly &
	fi

	# Start APM looping through play
	loopPlay ${1}
}

function apm_enable() {
	echo -n " Enabling MiSTer APM Autoplay..."
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
	echo " Done!"

	echo -n " APM autoplay daemon starting..."

	if [ "${1,,}" == "quickstart" ]; then
		/etc/init.d/S94misterapm &
	else
		/etc/init.d/S94misterapm
	fi
	
	echo " Done!"
	return
}

function apm_disable(){
	echo -n " Disabling APM autoplay..."
	# Clean out existing processes to ensure we can update
	serialKiller
	killall -q -9 S94misterapm
	killall -q -9 MiSTer_Player_MCP
	killall -q -9 MiSTer_APM_Mouse.sh
	killall -q -9 MiSTer_APM_Keyboard.sh
	killall -q -9 xxd
	kill -9 $(ps | grep "inotifywait" | grep "APM_Joy_Change" | cut --field=2 --only-delimited --delimiter=' ')

	mount | grep -q "on / .*[(,]ro[,$]" && RO_ROOT="true"
	[ "RO_ROOT" == "true" ] && mount / -o remount,rw 
	rm -f /etc/S94misterapm > /dev/null 2>&1
	sync
	[ "RO_ROOT" == "true" ] && mount / -o remount,ro 
	sync
	echo " Done!"
}

function apm_help(){
	echo " start - Start immediately"
	echo " skip - Skip to the next play"
	echo " stop - Stop immediately"
	echo ""
	echo " update - Self-Update"
	echo " monitor - Monitor APM output"
	echo ""
	echo " enable - Enable autoplay"
	echo " disable - Disable autoplay"
	echo ""
	echo " menu - Load menu"
	echo ""
	exit 2
}

#======== APM Parse Command's MENU ========
# Captura o Comando do MENU

function parse_cmd() {
	echo "${0}" # Nome do script
	echo "${#}" # Número de argumentos passado - menos $0
	echo "${?}"
	echo "${@}" # Todos os argumentos passados, semelhante ao $*
	echo "${1}" # Argumento 1
	echo "${2}" # Argumento 2
	echo "${1,,}" # Argumento 1
	echo "${*}" # Retorna todos os argumentos passados
	# We don't accept more than 2 parameters and no options
	# show the pre-menu
	# Validando se temos menos que 2 parametros e se não
	# tiver parametros, mostrar o pre-menu
	if [ ${#} -gt 2 ]; then
		apm_help
	elif [ ${#} -eq 0 ]; then
		apm_premenu
	else
		# If we're given a play name then we need to set it first
		nextplay=""
		for arg in ${@}; do
			case ${arg,,} in
				music | mp3 | audio | ost)
					echo " ${PLAY_PRETTY[${arg,,}]} selected!"
					nextplay="${arg}"
					;;
			esac
		done

		# If the one was a play then we need to call in again with "start" specified
		if [ ${nextplay} ] && [ ${#} -eq 1 ]; then
			# Move cursor up a line to avoid duplicate message
			echo -n -e "\033[A"
			# Re-enter this function with start added
			parse_cmd ${nextplay} start
			return
		fi

		while [ ${#} -gt 0 ]; do
			case ${1,,} in
				default) # Default is split because apm_update relaunches itself
					apm_update defaulttb
					break
					;;
				defaulttb)
					apm_update
					apm_enable quickstart
					apm_start
					break
					;;
				start) # Start APM immediately
					env_check ${1,,}
					tty_init
					apm_start
					pre_exit
					break
					;;
				skip | next) # Load next game - doesn't interrupt loop if running
					echo " Skipping to next play..."
					env_check @{1,,}
					tty_init
					next_play ${nextplay}
					break
					;;
				stop) # Stop APM immediately
					serialKiller
					echo " Thanks for playing!"
					pre_exit
					break
					;;
				update) # Update APM
					apm_update
					break
					;;
				enable)
					env_check ${1,,}
					apm_enable quickstart
					break
					;;
				disable) # Disable APM autoplay
					apm_disable
					break
					;;
				monitor) # Attach output to terminal
					apm_monitor
					break
					;;
				music | mp3 | audio | ost)
					: # Placeholder since we parsed these above
					;;
				utility)
					apm_utilitymenu
					break
					;;
				autoplay)
					apm_utilitymenu
					break
					;;
				config)
					apm_configmenu
					break
					;;
				back)
					apm_menu
					break
					;;
				menu)
					apm_menu
					break
					;;
				cancel) # Exit
					echo " It's pitch dark; You are to be eaten by a Grue."
					break
					;;
				help)
					apm_help
					break
					;;
				*)
					echo " ERROR! ${1} is unknow."
					echo " Try $(basename -- ${0}) help"
					echo " Or check the Github readme."
					break
					;;
			esac
			shift
		done
	fi
}

#======== APM UPDATE ========
# Funções para fazer o update e instalação do MiSTer_Player

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
			echo "No Internet connection"
			;;
	esac

	set -e
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

function get_apmstuff() { # get_apmstuff file (path)
	if [ -z "${1}" ]; then
		return 1
	fi

	filepath="${2}"
	if [ -z "${filepath}" ]; then
		filepath="${mrapmpath}"
	fi

	REPOSITORY_URL="https://github.com/how2security/MiSTer_Player"
	echo -n " Downloading from ${REPOSITORY_URL}/blob/${branch}/${1} to ${filepath}/..."
	curl_download "/tmp/${1##*/}" "${REPOSITORY_URL}/blob/${branch}/${1}?raw=true"

	if [ ! "${filepath}" == "/tmp" ]; then
		mv --force "/tmp/${1##*/}" "${filepath}/{1##*/}"
		mv --force "/tmp/${1##*/}" "${filepath}/${1##*/}"
	fi

	if [ "${1##*.}" == "sh" ]; then
		chmod +x "${filepath}/${1##*/}"
	fi

	echo " Done!"
}

function apm_update() { # apm_update (next command)
	# Ensure the MiSTer Player data directory exists
	mkdir --parents "${mrapmpath}" &>/dev/null

	# Prep curl
	curl_check

	if [ ! "$(dirname -- ${0})" == "/tmp" ]; then
		# Warn if using non-default branch for update
		if [ ! "${branch}" == "main" ]; then
			echo ""
			echo "**************************"
			echo " Updating from ${branch}"
			echo "**************************"
			echo ""

		fi

		# Download the newest MiSTer_APM_on.sh to /tmp
		get_apmstuff MiSTer_APM_on.sh /tmp
		if [ -f /tmp/MiSTer_APM_on.sh ]; then
			if [ ${1} ]; then
				echo " Continuing setup with latest"
				echo " MiSTer_APM_on.sh..."
				/tmp/MiSTer_APM_on.sh ${1}
				exit 0
			fi
		else
			# /tmp/MiSTer_APM_on.sh isn't there!
			echo " APM update FAILED"
			echo " No Internet?"
			exit 1
		fi
	else # We're running from /tmp - download dependencies and procced
		cp --force "/tmp/MiSTer_APM_on.sh" "/media/fat/Scripts/MiSTer_APM_on.sh"
		get_apmstuff .MiSTer_Player/MiSTer_APM_init
		get_apmstuff .MiSTer_Player/MiSTer_APM_MCP
		get_apmstuff .MiSTer_Player/MiSTer_APM_Joy.py 
		get_apmstuff .MiSTer_Player/MiSTer_APM_Keyboard.sh 
		get_apmstuff .MiSTer_Player/MiSTer_APM_Mouse.sh 
		get_apmstuff MiSTer_APM_off.sh /media/fat/Scripts

		if [ -f /media/fat/Scripts/MiSTer_APM.ini ]; then
			echo "MiSTER APM INI Already exists... SKIPPED!"
		else
			get_apmstuff MiSTer_APM.ini /media/fat/Scripts
		fi
	fi
	echo " Update complete!"
	return
}

function env_check() {
	# Check if we're been installed
	if [ ! -f "${mrapmpath}/MiSTer_APM_MCP" ]; then
		echo " APM required files not found."
		echo " Surprised? Check your INI."
		apm_update ${1}
		echo " Setup complete"
	fi 
}

function tty_init() { # tty_init
	# tty2oled initialization
	if [ "${ttyenable,,}" == "yes" ]; then
		#echo " Stopping tty2oled daemon..."
		#/etc/init.d/S60tty2oled stop
		#echo " Done!"
		
		echo "CMDCLS" > "${ttydevice}"
		echo "CMDTXT,0,1,0,9, Welcome to..." > "${ttydevice}"
		sleep 0.2
		echo "CMDCLS" > "${ttydevice}"
		echo "CMDTXT,0,1,0,9, Welcome to..." > "${ttydevice}"
		sleep 0.2
		echo "CMDCLS" > "${ttydevice}"
		echo "CMDTXT,0,1,0,9, Welcome to..." > "${ttydevice}"
		sleep 0.2
		echo "CMDTXT,2,1,47,27,  Super" > "${ttydevice}"
		sleep 0.2
		echo "CMDTXT,2,1,47,45,      Attract" > "${ttydevice}"
		sleep 0.2
		echo "CMDTXT,2,1,47,61,          Mode!" > "${ttydevice}"
	fi
}

function tty_update() { # tty_update core game
	if [ "${ttyenable,,}" == "yes" ]; then
		# Wait for tty2oled daemon to show the core logo
		inotifywait -e modify /tmp/CORENAME
		sleep 10
		
		# Transition effect
		echo "CMDGEO,8,1,126,30,31,15,0" > "${ttydevice}"
		sleep 0.2                                        
		echo "CMDGEO,8,1,126,30,63,31,0" > "${ttydevice}"
		sleep 0.2                                        
		echo "CMDGEO,8,1,126,30,127,63,0" > "${ttydevice}"
		sleep 0.2                                        
		echo "CMDGEO,8,1,126,30,255,127,0" > "${ttydevice}"
		sleep 0.2
		echo "CMDGEO,8,0,126,30,31,15,0" > "${ttydevice}"
		sleep 0.2                                        
		echo "CMDGEO,8,0,126,30,63,31,0" > "${ttydevice}"
		sleep 0.2                                        
		echo "CMDGEO,8,0,126,30,127,63,0" > "${ttydevice}"
		sleep 0.2                                        
		echo "CMDGEO,8,0,126,30,255,127,0" > "${ttydevice}"
		sleep 0.2                                        
		
		# Split long lines - length is approximate since fonts are variable width!
		if [ ${#2} -gt 23 ]; then
			echo "CMDTXT,2,1,0,20,${2:0:20}..." > "${ttydevice}"
			echo "CMDTXT,2,1,0,40, ${2:20}" > "${ttydevice}"
		else
			echo "CMDTXT,2,1,0,20,${2}" > "${ttydevice}"
		fi
		echo "CMDTXT,1,1,0,60,on ${1}" > "${ttydevice}"
	fi
}

function pre_exit() { # pre_exit
	#if [ "${usetty,,}" == "yes" ]; then /etc/init.d/S60tty2oled start; fi
	echo
}

function apm_monitor() {
	PID=$(ps aux | grep MiSTer_APM_on.sh | grep -v grep | awk '{print $1}' | head -n 1)

	if [ $PID ]; then
		echo -n " Attaching MiSTer APM to current shell..."
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
	
			echo "set \$fd=open(\"$_name\", $_mode)"
			echo "set \$xd=dup($_desc)"
			echo "call dup2(\$fd, $_desc)"
			echo "call close(\$fd)"

			if  [ $((_mode & 3)) ] && [ -n "$_msgs" ]; then
				_len=$(echo -en "$_msgs" | wc -c)
				echo "call write(\$xd, \"$_msgs\", $_len)"
			fi

			echo "call close(\$xd)"
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
			echo "#gdb script generated by running '$0 $ARGS'"
			echo "attach $PID"
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
		echo " Couldn't detect MiSTer_SAM_on.sh running"
	fi
}

function next_play() { # NextPlay(play)
	if [ -z "${playlist[@]//[[:blank:]]/}" ]; then
		echo " ERROR: FATAL - List of play music is empty. Nothing to do!"
		exit 1
	fi

	if [ -z "${1}" ]; then
		nextplay="$(echo ${playlist} | xargs shuf --head-count=1 --random-source=/dev/urandom --echo)"
	elif [ "${1,,}" == "countdown" ] && [ "$2" ]; then
		countdown="countdown"
		nextplay="${2}"
	elif [ "${2,,}" == "countdown" ]; then
		nextplay="${1}"
		countdown="countdown"
	fi

	load_play "${nextplay}"
}

function load_play() {
	echo -n " Starting now on the "
	echo -ne "\e[4m${PLAY_PRETTY[${1,,}]}\e[0m: "
	echo "$(date +%H:%M:%S) - ${1} - ${3}" >> /tmp/APM_PLAY.log
	tty_update "{PLAY_PRETTY[${1,,}]}" "${3}" &

	if [ "${4}" == "countdown" ]; then
		for i in {5..1}; do
			echo -ne " Loading music in ${i}...\033[OK\r"
			sleep 1
		done
	fi

	sleep 1
	echo "" |>/tmp/APM_Joystick_Activity
	echo "" |>/tmp/APM_Keyboard_Activity
	echo "" |>/tmp/APM_Mouse_Activity
}

init_data
parse_cmd ${@}
pre_exit
exit 0