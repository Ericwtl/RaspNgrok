#!/bin/sh
#----------用户配置----------
#sunny文件的目录
SUNNYDIR=/home/pi/ngrok

#你在ngrok.cc的地址，一般是free.ngrok.cc
SERVER=pi.mattholy.studio

#代理端口，在仪表盘可以看到
PORT=16404

#Sunny的管道ID
SUNNYID=a1a7ab9920d54f98
#---------------------------
timeout=5
target=https://www.ngrok.cc
ret_code=`curl -I -s --connect-timeout $timeout $target -w %{http_code} | tail -n1`
while [ "x$ret_code" != "x200" ]; do
	echo "[`date`]等待网络连接" | tee -a $SUNNYDIR/log.txt
	sleep 3
	ret_code=`curl -I -s --connect-timeout $timeout $target -w %{http_code} | tail -n1`
done
echo "[`date`]网络已连接，开始部署服务" | tee -a $SUNNYDIR/log.txt
$SUNNYDIR/sunny clientid $SUNNYID &
sleep 10
while true
do
	nc -z -v -w5 $SERVER $PORT >/dev/null 2>&1
	result1=$?
	if [ "$result1" != 0 ]; then
		echo "[`date`]监测到服务离线，尝试重启" | tee -a $SUNNYDIR/log.txt
		sudo killall -9 sunny
		/home/pi/ngrok/sunny clientid $SUNNYID &
		sleep 10
	else
		sleep 60
	fi
done
