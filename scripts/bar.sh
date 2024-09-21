#!/bin/sh

interval=0

# load colors
. ~/github/dwm-tt/scripts/bar_themes/nord

### BTC price ###
btc() {
	json_data=$(curl -s  https://api.coindesk.com/v1/bpi/currentprice.json)
	usd_rate=$(echo "$json_data" | jq -r '.bpi.USD.rate')
	icon="  "
	printf "^c$orange^%s ^c$white^%s " "$icon" "$usd_rate"
}

### CPU ###
cpu() {
	cpu=$(grep -o "^[^ ]*" /proc/loadavg)
    icon=""
    printf "^c$green^%s ^c$white^%s" "$icon" "$cpu%"
}

### TEMP ###
temp() {
	temp="$(sed 's/000$/°C/' /sys/class/thermal/thermal_zone12/temp)"
	icon=""
	printf "^c$red^%s ^c$white^%s" "$icon" "$temp"
}

### RAM ###
mem(){
         mem="$(free -h | awk '/^Mem/ { print $3"/"$2}' | sed s/i//g)"
         icon=""
         printf "^c$yellow^%s ^c$white^%s" "$icon" "$mem"
}

### BATTERY ###
bat() {

    cap="$(cat /sys/class/power_supply/BAT0/capacity)"
    stat="$(cat /sys/class/power_supply/BAT0/status)"
		
	if [ "$stat" = "Charging" ]; then
		icon=""
	else
		if [ "$cap" -le 24 ]; then
			icon=""
		elif [ "$cap" -le 49 ]; then
			icon=""
		elif [ "$cap" -le 74 ]; then
			icon=""
		elif [ "$cap" -le 94 ]; then
			icon=""
		else
			icon=""
		fi
	fi

	printf "^c$blue^%s ^c$white^%s" "$icon" "$cap%"
}

### Wifi ###
# wifi() {
# 	if [ "$(cat /sys/class/net/e*/operstate 2>/dev/null)" = 'up' ] ; then
#         	icon=""
# 	elif [ "$(cat /sys/class/net/w*/operstate 2>/dev/null)" = 'up' ] ; then
#         	icon=""
# 	else
# 		icon=""
# 	fi
# 	printf "^b$grey^ %s  ^d^" "$icon"
# }

### VOLUME ###
vol(){
       	#vol="$(amixer -D pulse get Master | awk -F'[][]' 'END{print $4":"$2}')"
	vol="$(pactl list sinks | awk '/Volume:/ {print $5}' | head -n 1 | tr -d '%')%"
        icon=""
        printf "^c$purple^%s ^c$white^%s" "$icon" "$vol"
}

### Time ###
tm() {
	time="$(date +"%H:%M:%S")"
	icon=""
	printf "^c$black^^b$darkblue^ %s  ^c$white^^b$grey^ %s" "$icon" "$time"
}

### PACKAGES ###
#pkg_updates() {
#        updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc ->
#        icon=""
#        printf "%s %s" "$icon" "$updates"
#}

# Main loop
while true; do
	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] # && updates=$(pkg_updates)
	interval=$((interval + 1))
	sleep 1 && xsetroot -name "$(btc) $(cpu)  $(temp)  $(mem)  $(bat)  $(vol)  $(tm) "
done
