#!/bin/bash

rm -rf /root/install.sh >/dev/null 2>&1

clear
MYIP=$(curl -sS ipv4.icanhazip.com)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')

date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/MarocBeta/Permission/main/access"

clear
checking_sc() {
useexp=$(wget -qO- $data_ip | grep $MYIP | awk '{print $3}')
if [[ $date_list < $useexp ]]; then
echo -ne
else
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -e "\033[42m          404 NOT FOUND AUTOSCRIPT          \033[0m"
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -e ""
echo -e "            \033[91;1mPERMISSION DENIED !\033[0m"
echo -e "   \033[0;33mYour VPS\033[0m $MYIP \033[0;33mHas been Banned\033[0m"
echo -e "     \033[0;33mBuy access permissions for scripts\033[0m"
echo -e "             \033[0;33mContact Admin :\033[0m"
echo -e "      \033[2;32mWhatsApp:\033[0m wa.me/212608607325"
echo -e "      \033[2;32mTelegram:\033[0m t.me/MarocBeta"
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
exit 0
fi
}

checking_sc

RED="\033[31m"
YELLOW="\033[33m"
NC='\e[0m'

clear

if [ "$EUID" -ne 0 ]; then
echo -e "${RED}You need to run this script as root!${NC}"
exit 0
fi

domain=$(cat /etc/xray/domain)

echo -e "${YELLOW}Do you want to install BotPanel? (y/n)${NC}"
read answer
if [[ $answer != "y" && $answer != "Y" ]]; then
echo -e "${RED}Installation Canceled!${NC}"
exit 0
fi

apt update && apt upgrade -y
apt install python3-telethon -y >/dev/null 2>&1
apt install unzip cron at p7zip-full >/dev/null 2>&1
wget -q https://github.com/MarocBeta/BotPanel/archive/refs/heads/main.zip -O /tmp/BotPanel.zip
unzip /tmp/BotPanel.zip -d /usr/bin
rm -rf /tmp/BotPanel.zip
mv /usr/bin/BotPanel-main /usr/bin/BotPanel
pip3 install -r /usr/bin/BotPanel/requirements.txt
cd /usr/bin/BotPanel/modules
7z x -p@kbmnglntr45 modules.zip > /dev/null 2>&1
mv /usr/bin/BotPanel/modules/modules/* /usr/bin/BotPanel/modules
rm -r /usr/bin/BotPanel/modules/modules
rm -rf modules.zip
cd /usr/bin
rm -rf /usr/bin/BotPanel/install.sh

clear

echo ""
read -e -p "[+] Enter Your Bot Token : " bottoken
read -e -p "[+] Enter Your ID Telegram : " admin

echo ""
echo -e BOT_TOKEN='"'$bottoken'"' >> /usr/bin/BotPanel/data.txt
echo -e ADMIN='"'$admin'"' >> /usr/bin/BotPanel/data.txt
echo -e DOMAIN='"'$domain'"' >> /usr/bin/BotPanel/data.txt

clear
echo ""
echo "Your Data Bot"
echo -e "•=================================•"
echo "Bot Token     : $bottoken"
echo "ID Telegram   : $admin"
echo "Subdomain     : $domain"
echo -e "•==================================•"
echo "Setting done Please wait 5 seconds!"
sleep 5

cat > /etc/systemd/system/BotPanel.service << END
[Unit]
Description=BotPanel - By @MarocBeta
After=network.target
[Service]
Type=simple
User=root
WorkingDirectory=/usr/bin/
ExecStart=/usr/bin/python3 -m BotPanel
Restart=always
[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload

systemctl start BotPanel
systemctl enable BotPanel
systemctl restart BotPanel

clear
echo ""
echo -e "•================================================•"
echo " Installations complete, type /start on your bot"
echo -e "•================================================•"
echo ""
read -n 1 -s -r -p "Press enter to go to the menu"
menu
