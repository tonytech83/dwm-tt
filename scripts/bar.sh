#!/bin/sh

interval=0

### Time ###
tm() {
	time="$(date +"%H:%M:%S")"
	icon=""
	printf "%s %s" "$icon" "$time"
}

### RAM ###
mem(){
         mem="$(free -h | awk '/^Mem/ { print $3"/"$2}' | sed s/i//g)"
         icon=""
         printf "%s %s" "$icon" "$mem"
}

### CPU ###
cpu(){
         cpu=$(grep -o "^[^ ]*" /proc/loadavg)
         icon=""
         printf " %s %s" "$icon" "$cpu%"
}

### PACKAGES ###
#pkg_updates() {
#        updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc ->
#        icon=""
#        printf "%s %s" "$icon" "$updates"
#}

### TEMP ###
temp() {
	temp="$(sed 's/000$/°C/' /sys/class/thermal/thermal_zone12/temp)"
	icon=""
	printf "%s %s" "$icon" "$temp"
}

### BATTERY ###
bat() {
#	cap=$(cat /sys/class/power_supply/BAT0/capacity)
#	if [ $cap eq 100) ]; then
#		icon=""
#	elif [ $cap 
        battery="$(cat /sys/class/power_supply/BAT0/capacity)"
        icon=""
        printf "%s %s" "$icon" "$battery%"
}

### VOLUME ###
vol(){
       	#vol="$(amixer -D pulse get Master | awk -F'[][]' 'END{print $4":"$2}')"
	vol="$(pactl list sinks | awk '/Volume:/ {print $5}' | head -n 1 | tr -d '%')%"
        icon=""
        printf "%s %s" "$icon" "$vol"
}

### Wifi ###
wifi() {
	if [ "$(cat /sys/class/net/e*/operstate 2>/dev/null)" = 'up' ] ; then
        	icon=""
	elif [ "$(cat /sys/class/net/w*/operstate 2>/dev/null)" = 'up' ] ; then
        	icon=""
	else
		icon=""
	fi
	printf "%s" "$icon"
}

# Initial updates
vol

# Main loop
while true; do
	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] # && updates=$(pkg_updates)
	interval=$((interval + 1))
	sleep 1 && xsetroot -name "$(cpu)  $(mem)  $(temp)  $(bat)  $(wifi)  $(vol)  $(tm) "
done
