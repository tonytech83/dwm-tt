# Scaling the desktop without changing the resolution
- Getting the screen name:
```sh
xrandr | grep connected | grep -v disconnected | awk '{print $1}'
```
- Reduce the screen size by 20% (zoom-in)
```sh
xrandr --output screen-name --scale 0.8x0.8
```
- Increase the screen size by 20% (zoom-out)
```sh
xrandr --output screen-name --scale 1.2x1.2
```
- Reset xrandr changes
```sh
xrandr --output screen-name --scale 1x1
```
