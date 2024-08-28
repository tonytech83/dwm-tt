#!/bin/sh

interval=0

### Time ###
tm() {
	time="$(date +"%H:%M:%S")"
	printf "%s" "$time"
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

### TEMP ###
temp() {
	temp="$(sed 's/000$/°C/' /sys/class/thermal/thermal_zone12/temp)"
	printf "%s" "$temp"
}

### BATTERY ###
bat() {
         battery="$(cat /sys/class/power_supply/BAT0/capacity)"
         icon=""
         printf "%s %s" "$icon" "$battery%"
}

### Wifi ###
wifi() {
	if [ "$(cat /sys/class/net/w*/operstate 2>/dev/null)" = 'up' ] ; then
        	wifiicon="$(awk '/^\s*w/ { print "📶", int($3 * 100 / 70) "%" }' /proc/net/wireless)"
	elif [ "$(cat /sys/class/net/w*/operstate 2>/dev/null)" = 'down' ] ; then
        	[ "$(cat /sys/class/net/w*/flags 2>/dev/null)" = '0x1003' ] && wifiicon="📡 " || wifiicon="❌ "
	fi
	printf "%s" "$wifiicon"
}

# Main loop
while true; do
	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ]
	interval=$((interval + 1))
	sleep 1 && xsetroot -name "[ $(cpu) ][ $(temp) ][ $(mem) ][ $(bat) ][ $(wifi)  ][ $(tm) ]"
done
