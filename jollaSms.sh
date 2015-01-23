#!/bin/sh
# log file
export logfile="$HOME/.jsms-log"
# contacts file
export contacts="$HOME/.jsms-contacts"
# IP or DNS of jolla
export jolladdr="jolla"
#Area Code
export areacode="+39"

usage()
{
    echo " "
    echo "Usage: jsms <alias|number> <message>"
    echo " "
    exit 1
}

check_input_param()
{
    if [ $# -lt 2 ]
	then
	   usage
	fi
}

checkContact()
{
	while read  line
	do
		name=""
		num=""
		i=0
        name=$(echo $line | cut -d"," -f1)
		num=$(echo $line | cut -d"," -f2)
		if [ "$num" = $1 -o "$name" = $1 ]
		then
		    echo $num
			return
		fi
	done < $contacts
	
	return 
}

#Number parameter control
check_input_param $*
outNum=$(checkContact $1)	
            
shift
for arg in $*
do
	msg="$msg  $arg"
done

msg=$( echo $msg | awk '{gsub(/"/, "\"");gsub ( "/[:\47]/","'"'"''"'"'" ); print;}')


if [ -z $outNum ]
then
	echo "--invalid contact"	
else
    ssh nemo@$jolladdr ''dbus-send --system --print-reply --dest=org.ofono /ril_0 org.ofono.MessageManager.SendMessage string:\"$areacode$outNum\" string:\"$msg\"''
	if [ "$?" -ne "0" ]
	then
	 echo "Error sending message"
	 exit 1
	else
	 echo "message sent"                   
	 current_time=$(date "+%Y-%m-%d %H:%M:%S")
     echo $current_time " " $areacode$outNum " " $msg >> $logfile
     num=`ssh nemo@$jolladdr commhistory-tool listgroups | grep ^Group | grep $outNum`
	 
#new Line NON MOVE this statement	
export IFS="
"
	 for row in $num; do
		existgroup=$(echo $row | cut -d" " -f2)
		break
	 done  
	 if [ -z $existgroup ]
	 then
	    existgroup="-newgroup"
	 else
	   existgroup="-group $existgroup"
	 fi
	 ssh nemo@$jolladdr commhistory-tool add $existgroup -text \"$msg\" -out -sms "''" $outNum
	 exit 0
	fi 
fi
