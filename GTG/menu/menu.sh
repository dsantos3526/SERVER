#!/bin/bash

echo -e "[*][*][*]======================================[*][*][*]"      | lolcat
echo -e "                                                  "            | lolcat
echo -e "            Panel Utama GTG COMPUTER"                          | lolcat
echo -e "                                                          "    | lolcat
echo -e "    [1] Panel SSH (SSH, WebsocketSSH & OpenVPN)"               | lolcat
echo -e "    [2] Panel V2ray (Vmess, Vless, Trojan)"                    | lolcat
echo -e "    [4] Panel Shadowsocks (ShadowsocksR & Shadowsocks OBFS)"   | lolcat
echo -e "    [3] Panel Wireguard"                                       | lolcat
echo -e "    [4] Panel PSP (L2TP, SSTP, PPTP)"                          | lolcat
echo -e "    [x] Exit"                                                  | lolcat
echo -e "                                                   "           | lolcat
read -p "      Select From Options [1-4 or x] :  " vvt
echo -e "                                                   "           | lolcat
echo -e "[*][*][*]======================================[*][*][*]"      | lolcat
clear
case $vvt in

1)
panel-ssh
;;
2)
panel-v2ray
;;
3)
panel-ss
;;
4)
panel-wg
;;
x)
panel-psp
;;
*)
echo "Please enter an correct number"
;;
esac