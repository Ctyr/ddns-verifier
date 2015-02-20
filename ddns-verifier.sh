#!/bin/bash
#description:this program automatically analyse the /var/log/auth.log to verify the ssh authentication . working with crontab.
#2014-11-8 --basic function
#2014-11-9 --use diff
#writed by Tyr.Chen


takeAction()
{
	readip=`cat /tmp/attacker_ip`
	if [ "$readip" != "$1" ];then
		echo "`date`	illegal ip:$1	ddns ip:$log_ddns_ip" >>/var/log/ddns-verifier.error
		echo "
    	`date`
    	detect ddns resolve ip is:$log_ddns_ip
    	ssh login ip is : $1
    	you must take action!!!
    	" |mutt -s "Waring:ssh illegal login" email@example.com
		echo $1 > /tmp/attacker_ip
	fi
}
logLegallogin()
{
	loginip=`cat /tmp/sshlogin_ip`
	if [ "$loginip" != "$1" ];then
		echo "`date`  success ssh login ip:$1" >> /var/log/ddns-verifier.ok
		echo $1 > /tmp/sshlogin_ip
	fi
}
log_ddns_ip=`dig +short ddns.example.com A | egrep  "^[0-9.]+$"`
log_date=`date +"%b %_d"`

log_ssh_ip=`cat /var/log/auth.log | grep "$log_date.*sshd.*Accepted password for"|sed -e 's/.*from //g' -e 's/ .*$//g' | diff /tmp/logFullIp - | egrep "^> [0-9.]+"| sed 's/> //g'`

for i in $log_ssh_ip
do
	if [ -n "$i" -a "$log_ddns_ip" != "$i" ];then
		takeAction $i
	else
		logLegallogin $i
	fi
done
cat /var/log/auth.log | grep "$log_date.*sshd.*Accepted password for"| sed -e 's/.*from //g' -e 's/ .*$//g' > /tmp/logFullIp
exit 0 

