#!/bin/sh
echo "\e[2J\e[1;1H"
echo "===================================================================="
echo "                这是马特浩倪的Sunny-Ngrok一键装载系统               "
echo "它的特性"
echo "  ┣━1.自动化部署Sunny-Ngrok服务"
echo "  ┣━2.开机自动启动Sunny-Ngrok"
echo "  ┗━3.实现自动监测，断线后可以重连"
echo "--------------------------------------------------------------------"
echo "按任意键继续......\c"
read anykey
echo "\e[2J\e[1;1H"
echo "===================================================================="
echo "┣┳请输入你希望Sunny-Ngrok安装的位置,出于安全考虑，只能在用户文件夹下创建"
echo "┃┣将会自动在该目录下创建文件夹用于存放Sunny-Ngrok"
echo "┃┣直接按回车建将在/home/${USER}下创建,\033[31;1m请不要在路径最后输入/符号\033[0m"
echo "┃┗▶/home/${USER}\c"
read INSDIR
echo "┣━正在检测路径合法性"
while [ ! -d "/home/${USER}${INSDIR}" ]; do
  echo "┣┳\033[31;1m/home/${USER}${INSDIR}不存在或者无权限访问，请重新选择\033[0m"
  echo "┃┗▶/home/${USER}\c"
  read INSDIR
done
echo "┣━\033[32;1m位置有效，程序将会下载到/home/${USER}${INSDIR}/RaspNgrok\033[0m"
echo "┣━连接下载服务器"
echo "┣━\e[s\033[5m正在下载......\033[0m"
cd /home/${USER}${INSDIR}
git clone git://github.com/mattholy/RaspNgrok.git 1>/dev/null 2>&1
echo "\e[u\e[32;1m下载完成                      \e[0m "
echo "┣━设置权限"
cd RaspNgrok
sudo chmod -R +777 /home/${USER}${INSDIR}/RaspNgrok
sed -i "6c ExecStart=/home/${USER}${INSDIR}/RaspNgrok/ngrok.sh" sunny.service
sed -i "4c SUNNYDIR=/home/${USER}${INSDIR}/RaspNgrok" ngrok.sh
echo "┣┳请输入你的Sunny地址，一般是free.ngrok.cc"
echo "┃┣稍后你可以在/home/${USER}${INSDIR}/RaspNgrok/ngrok.sh修改"
echo "┃┗▶\c"
read USERADD
sed -i "7c SERVER=${USERADD}" ngrok.sh
echo "┣┳请输入你的Sunny管道端口，可在www.ngrok.cc仪表盘查看"
echo "┃┣稍后你可以在/home/${USER}${INSDIR}/RaspNgrok/ngrok.sh修改"
echo "┃┗▶\c"
read USERPORT
sed -i "10c PORT=${USERPORT}" ngrok.sh
echo "┣┳请输入你的Sunny管道ID，可在www.ngrok.cc仪表盘查看"
echo "┃┣稍后你可以在/home/${USER}${INSDIR}/RaspNgrok/ngrok.sh修改"
echo "┃┗▶\c"
read USERID
sed -i "13c SUNNYID=${USERID}" ngrok.sh
echo "┣━正在注册系统自启服务"
sudo mv -f sunny.service /etc/systemd/system
sudo systemctl start sunny
sudo systemctl enable sunny
echo "┣━注册完成！"
echo "┣━你可以输入\033[34;1m systemctl status sunny\033[0m 查看运行情况"
echo "┣━日志位于\033[34;1m /home/${USER}${INSDIR}/RaspNgrok/log.txt\033[0m"
echo "┗感谢使用"
echo "===================================================================="
echo "是否要重启树莓派来验证生效？(y/n)\c"
read choice
if [ ${choice} = y ]; then
  sudo reboot
elif [ ${choice} = n ]; then
  exit 0
else
  echo "??????????????????????WTF"
fi
