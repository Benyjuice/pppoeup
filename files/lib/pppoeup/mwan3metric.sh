#/bin/bash
#Program:
#	This script is use  to insect a new line after 'config interface 'wanx''
#History:
#2014/10/21	lzh	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~bin
export PATH

USAGE="\
Usage:
	./mwan3metric <number> <0/1> <file>
<number>:
	taken in [10-99]
	the first new line that insected will be created like this:
	option metric 'number'
	the 'number' will increase after each creation.
<0/1>:
	delete/set
	0:delete all the lines that had been created before.
	1:use to creat the line after the 'wanx' being found.
<file>:
	the file you want to write in.
	ex:/etc/config/network"
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -z "$4" ];then
	if [ $1 -gt 9 ] && [ $1 -lt 100 ] && [ $2 -ge  0 ] && [ $2 -lt 2 ]; then
	number=$1
	ds=$2
	file=$3
	echo "$file"
	else
		echo "$USAGE"
		exit 1
	fi
else
	echo "$USAGE"
	exit 1
fi

i=1
oldnumber=`cat $file | grep "option metric" | cut -c 17-18 | head -n 1`
if [ "$oldnumber" = "" ]; then
	oldnumber=0
fi
if [ $ds = 1 ]; then
	if [ $oldnumber = 0 ]; then
		sed -i -e "/config interface 'wan'$/a\	option metric '$number'" $file
	else
		sed -i "s/option metric '$oldnumber'/option metric '$number'/g" $file
	fi
	while [ 1 ]
	do
		grep "config interface 'wan$i'" $file
		if [ $? != 0 ];then
			break
		fi
		grep "option metric '$(($i+$oldnumber))'" $file
		if [ $? = 0 ];then
			sed -i "s/option metric '$(($oldnumber+$i))'/option metric '$(($number+$i))'/g" $file
			i=$(($i+1))
			continue
		else
			sed -i -e "/config interface 'wan$i'/a\	option metric '$(($i+$number))'" $file
			i=$(($i+1))
		fi
	done
else
	sed -i -e "/option metric '$oldnumber'/d " $file
	while [ 1 ]
	do	
		grep "config interface 'wan$i'" $file
		if [ $? != 0 ];then 
			break
		fi
		grep "option metric '$(($i+$oldnumber))'" $file
		sed -i -e "/option metric '$(($i+$oldnumber))'/d " $file
		i=$(($i+1)) 
	done
fi
exit 0
