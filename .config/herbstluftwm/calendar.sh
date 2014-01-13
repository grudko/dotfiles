#!/bin/bash
#
# pop-up calendar for dzen
#
# based on (c) 2007, by Robert Manea
# http://dzen.geekmode.org/dwiki/doku.php?id=dzen:calendar
# modified by urukrama
#

TODAY=$(expr `date +'%d'` + 0)
MONTH=`date +'%m'`
YEAR=`date +'%Y'`
width=180
padding=1
monitor=( $(herbstclient list_monitors |
    grep '\[FOCUS\]$'|cut -d' ' -f2|
    tr x ' '|sed 's/\([-+]\)/ \1/g') )
x=$((${monitor[2]} + ${monitor[0]} - width - padding))
y=$((${monitor[1]} - 310 ))
echo $y
(
cal -NbMh | sed -r -e "1,2 s/.*/^fg(#ffffff)&^fg()/" \
 -e "s/(^| )($TODAY| $TODAY)($| )/\1^fg(#ff00a0)\2^fg()\3/"

[ $MONTH -eq 12 ] && YEAR=`expr $YEAR + 1`
cal -NbMh `expr \( $MONTH + 1 \) % 12` $YEAR | sed -e "1,2 s/.*/^fg(#ffffff)&^fg()/"
sleep 8
) | dzen2 -fg '#6c6c6c' -bg '#1c1c1c' -x $x -y $y \
          -w $width -l 15 -sa c -e "onstart=uncollapse;button1=exit"
