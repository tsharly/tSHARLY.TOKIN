#!/usr/bin/env bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

install() {
		sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get install lua5.1 lua-socket lua-sec redis-server curl -y
		sudo apt-get install libreadline-dev libssl-dev lua5.2 luarocks liblua5.2-dev curl libcurl4-gnutls-dev -y
		git clone http://github.com/keplerproject/luarocks
		cd luarocks
		./configure --lua-version=5.2
		make build
		sudo make install
		sudo luarocks install Lua-cURL
		sudo luarocks install oauth
		sudo luarocks install redis-lua
		sudo luarocks install lua-cjson
		sudo luarocks install ansicolors
		sudo luarocks install serpent
		cd ..
}

function print_logo() {
	green " "
	green "                                 #####   #     #     #     ######   #        #     # 
                         #####  #     #  #     #    # #    #     #  #         #   #  
                           #    #        #     #   #   #   #     #  #          # #   
                           #     #####   #######  #     #  ######   #           #    
                           #          #  #     #  #######  #   #    #           #    
                           #    #     #  #     #  #     #  #    #   #           #    
                           #     #####   #     #  #     #  #     #  #######     #    "
	green " "
	green " "
	echo -e "\n\e[0m"
}

function logo_play() {
    declare -A txtlogo
    seconds="0.010"
    txtlogo[1]=" "
    txtlogo[2]="                         #####   #     #     #     ######   #        #     # 
                         #####  #     #  #     #    # #    #     #  #         #   #  
                           #    #        #     #   #   #   #     #  #          # #   
                           #     #####   #######  #     #  ######   #           #    
                           #          #  #     #  #######  #   #    #           #    
                           #    #     #  #     #  #     #  #    #   #           #    
                           #     #####   #     #  #     #  #     #  #######     #    "
    txtlogo[3]=" "
    txtlogo[4]=" "
    printf "\e[31m\t"
    for i in ${!txtlogo[@]}; do
        for x in `seq 0 ${#txtlogo[$i]}`; do
            printf "${txtlogo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
    printf "\n"
	echo -e "\e[0m"
}

function TSHARLY() {
	echo -e "\e[0m"
   	  red "     >>>>                       ًںŒں| ظ†ط­ظ† ط§ظ„ط§ظپط¶ظ„                                 "
        green "     >>>>                       ًںŒں| ظ†ط­ظ† ط§ظ„ط§ظ‚ظˆظ‰                                 "
	white "     >>>>                       ًںŒں| ظ†ط­ظ† ط§ظ„ظ…ط¨ط±ظ…ط¬ظٹظ†                             "
	white "     >>>>                       ًںŒں| ط§ط·ظ„ط¨ ط³ظˆط±ط³ظƒ ط§ظ„ط§ظ†                            "
	  red "     >>>>                       ًںŒں| ظ†ط­ظ† ط¹ط§ط¦ظ„ظ‡ ظˆط§ط­ط¯ظ‡                           "
	  red "     >>>>                       ًںŒں| @DEVASL TEAM THE BEST                      "
	echo -e "\e[0m"
}

red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
white() {
  printf '\e[1;37m%s\n\e[0;39;49m' "$@"
}
update() {
	git pull
}

if [ "$1" = "install" ]; then
	print_logo
	TSHARLY
	logo_play
	install
elif [ "$1" = "update" ]; then
	logo_play
	TSHARLY
	update
	exit 1
else
	print_logo
	TSHARLY
	logo_play
	green " ط³ظ€ظˆط±ط³ طھظ€ظ€ط´ط§ط±ظ„ظ€ظٹ ظٹط¹ظ…ظ„ ط§ظ„ط§ظ† ..."
	lua ./bot/bot.lua
fi
