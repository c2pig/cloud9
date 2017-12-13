#!/bin/bash
#   Slick Progress Bar
#   Created by: Ian Brown (ijbrown@hotmail.com)
#   Please share with me your modifications
# Note: From http://stackoverflow.com/questions/11592583/bash-progress-bar
# Functions
rm .stack
PUT(){ echo -en "\033[${1};${2}H";}  
DRAW(){ echo -en "\033%";echo -en "\033(0";}         
WRITE(){ echo -en "\033(B";}  
HIDECURSOR(){ echo -en "\033[?25l";} 
NORM(){ echo -en "\033[?12l\033[?25h";}
MSG="Be Patient.."
function showBar {
        percDone=$(echo 'scale=2;'$1/$2*100 | bc)
        halfDone=$(echo $percDone/2 | bc) #I prefer a half sized bar graph
        halfDone=`expr $halfDone + 6`
        tput bold
        PUT 7 38; printf "$MSG"
        PUT 5 $halfDone;  echo -e "\033[7m \033[0m" #Draw the bar
        tput sgr0
}
# Start Script
PROGRESS() {
	clear
	HIDECURSOR
	echo -e ""                                           
	echo -e ""                                          
	DRAW    #magic starts here - must use caps in draw mode                                              
	echo -e "                            CLOUD9 STACK CREATION IS IN PROGRESS"
	echo -e "    lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk"  
	echo -e "    x                                                                                 x" 
	echo -e "    mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj"
	WRITE             
	for (( i=0; i<=80; i++ ))  
	do
	    showBar $i 50
	    sleep .05
	done
}



./stack.sh &
count=0
while [ ! -e .stack ] && [ ${count} -lt 4 ]; do
  PROGRESS "$MSG"
  count=$((count+1))
  [ $count -eq 1 ] && { MSG="Getting There..."; }
  [ $count -eq 2 ] && { MSG="Almost There..."; }
  [ $count -eq 3 ] && { MSG="Closer To Completion..."; }
done

PUT 10 12                                           
BLUE='\033[0;34m'
NC='\033[0m'
echo -e ""
echo -e ""
echo -e ""
echo -e "Stack Creation Complete!"
echo -e "Bear in mind that this stack will be \033[5mself-destroyed after $hours Hours\033[0m"
echo ""
echo -e "Execute following command to retrive your Test Report:"
echo ""
printf "${BLUE} ./cloud.sh report e60cb542-df51-11e7-80c1-9a214cf093ae${NC}"
echo ""
