#!/bin/sh /etc/rc.common
#Program:
#This script is used to configure the FILE of mwan3 on openwrt.
#Description:
#	To automatically set the wans into the /etc/config/mwan3
#History:
#2014/10/30	LiZhihong	Ver:2.0
#You can send an e-mail to me while you found any bug in this script.
#E-mail:youmonanhaizi@163.com
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~bin
export PATH

USAGE_V2="\
Usage:
	./mwan3config start
	    Automatically,the 'autocount' will be found 
	    in /etc/config/pppoeup.Then set autocount wans
	    into the /etc/config/mwan3.
	[autocount]:1~x
	    1	:Remove all the wanY,and disable wan.
	    x	:Set x wans,and enable them."
ADDX()
{
	ipa=$(uci get mwan3.wan.track_ip | cut -d ' ' -f 1)
	ipb=$(uci get mwan3.wan.track_ip | cut -d ' ' -f 2)
	reliability=$(uci get mwan3.wan.reliability)
	count=$(uci get mwan3.wan.count)
	timeout=$(uci get mwan3.wan.timeout)
	interval=$(uci get mwan3.wan.interval)
	down=$(uci get mwan3.wan.down)
	up=$(uci get mwan3.wan.up)

	x=$1
	y=$(($1-1))
	xfile=$2
	[ $y -eq 0 ] && y=""
#	echo "function ADDX"
	sed -i -e "/list use_member 'wan${y}_m1_w3'/a\	list use_member 'wan${x}_m1_w3'" $xfile
	echo -e "config interface 'wan${x}'\n\toption reliability $reliability\n\toption count $count\n\toption timeout $timeout\n\toption interval $interval\n\toption down $down\n\toption up $up\n\tlist track_ip "$ipa"\n\tlist track_ip "$ipb"\n\toption enabled '1'\n" >> $xfile
	echo -e "config member 'wan${x}_m1_w3'\n\toption interface 'wan${x}'\n\toption metric '1'\n\toption weight '3'\n" >> $xfile
}

DELETEX()
{
#	echo "function DELETEX"
	x=$1
	Xfile=$2
	sed -i -e "/	list use_member 'wan${x}_m1_w3'/d" $Xfile
	beginline=`grep -n "config interface 'wan${x}'" $Xfile | cut -d ":" -f1`
	endline=$(($beginline+10))
	sed -i -e "${beginline},${endline}d" $Xfile
	beginline=`grep -n "config member 'wan${x}_m1_w3'" $Xfile | cut -d ":" -f1`
	endline=$(($beginline+4))
	sed -i -e "${beginline},${endline}d" $Xfile
}

UNSET(){
	ufile=$1
#	echo "function UNSET"
	ucount=`grep -c "list use_member 'wan" $ufile`
	[ $ucount -eq 1 ] && return 0
	ui=1
	while [ $ui -lt $ucount ]
	do
		DELETEX $ui $ufile
		ui=$(($ui+1))
	done
	sed -i -e "s/option enabled '1'/option enabled '0'/g" $ufile
}

SET(){
	scount=$1
	sfile=$2
	[ $scount -eq 0 ] && echo "You can't set 0 wan." && exit 1
#	echo "function SET"
	UNSET $sfile
	[ $scount -eq 1 ] || sed -i -e "s/option enabled '0'/option enabled '1'/g" $sfile
	i=1
	while [ $i -lt $scount ]
	do
		ADDX $i $sfile
		i=$(($i+1))
	done
	exit 0
}

start(){ 
#[ -z "$1" ] && OPTION="auto" || OPTION=$1
[ -z "$1" ] && OPTION="s" || OPTION="h"
case $OPTION in
	"s")
########################   Ver:2   ####################################
#maybe the two lines that followed will be rewrited by BrightMoon#
	autocount=$(uci get pppoeup.settings.mwan3_number)
	SET $autocount /etc/config/mwan3
#######################################################################
	;;
	"*")
	echo "$USAGE_V2"
	exit 1
	;;
esac
}
