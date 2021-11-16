#!/bin/bash

echo -e "[*][*][*]==========================-MENU-=========================[*][*][*]"      | lolcat
echo -e "[*]                                                                     [*]"      | lolcat
echo -e "==========================================================================="      | lolcat
echo -e ""| lolcat
echo -e "  Panel SSH (SSH, WebsocketSSH & OpenVPN)             : 1 / [panel-ssh]    "| lolcat
echo -e "  Panel V2ray (Vmess, Vless, Trojan)                  : 2 / [panel-v2ray]  "| lolcat
echo -e "  Panel LSP (L2TP, SSTP, PPTP)                        : 3 / [panel-lsp]    "| lolcat
echo -e "  Panel Wireguard                                     : 4 / [panel-wg]     "| lolcat
echo -e "  Panel Shadowsocks (ShadowsocksR & Shadowsocks OBFS) : 5 / [panel-ss]     "| lolcat
echo -e ""| lolcat
echo -e "[*][*][*]==========================-SYSTEM-=======================[*][*][*]"| lolcat
echo -e ""| lolcat
echo -e "===================================================================="| lolcat
echo -e ""| lolcat
echo -e "* Add Or Change Subdomain Host For VPS                 : 6 / [add-domain]"| lolcat
echo -e "* Change Port of Some Service                          : 7 / [change-port]"| lolcat
echo -e "* Webmin Menu                                          : 8 / [webmin]"| lolcat
echo -e "* Update To Latest Kernel                              : 9 / [update-kernel]"| lolcat
echo -e "* Limit Bandwith Speed Server                          : 10 / [limit]"| lolcat
echo -e "* Check Usage of VPS Ram                               : 11 / [ram]"| lolcat
echo -e "* Reboot VPS                                           : 12 / [reboot]"| lolcat
echo -e "* Speedtest VPS                                        : 13 / [speedtest]"| lolcat
echo -e "* Update To Latest Script Version                      : 14 / [update]"| lolcat
echo -e "* Displaying System Information                        : 15 / [info]"| lolcat
echo -e "* Info Script Auto Install                             : 16 / [about]"| lolcat
echo -e "* Exit From VPS                                        : 17 / [exit]"| lolcat
echo -e "===================================================================="| lolcat
echo -e "                   Exit = type anything !"| lolcat
echo -e "===================================================================="| lolcat
echo ""| lolcat
echo -n "   Enter Your Option : "| lolcat 
read -r jawab | lolcat
echo -e "===================================================================="| lolcat

#Panel SSH
function panel-ssh) {
clear
echo -e "=================== Panel SSH, WebsocketSSH & OpenVPN-===================="
echo -e "* Create SSH & OpenVPN Account                         : 18 / [new]  "
echo -e "* Generate SSH & OpenVPN Trial Account                 : 19 / [trial]  "
echo -e "* Extending SSH & OpenVPN Account Active Life          : 20 / [renew]  "
echo -e "* Delete SSH & OpenVPN Account                         : 21 / [delete] "
echo -e "* Check User Login SSH & OpenVPN                       : 22 / [cek]    "
echo -e "* Daftar Member SSH & OpenVPN                          : 23 / [list]   "
echo -e "* Delete User Expired SSH & OpenVPN                    : 24 / [deleteuser] "
echo -e "* Set up Autokill SSH                                  : 25 / [autokill]   "
echo -e "* Displays Users Who Do Multi Login SSH                : 26 / [] "
echo -e "* Restart Service Dropbear, Squid3, OpenVPN and SSH                 "

}


#Panel V2ray
function panel-v2ray() {
clear
echo -e "===============================-Panel V2ray-================================"
echo -e "* add-vmess    : Create V2RAY Vmess Websocket Account"
echo -e "* del-vmess    : Deleting V2RAY Vmess Websocket Account"
echo -e "* renew-vmess  : Extending Vmess Account Active Life"
echo -e "* check-vmess  : Check User Login V2RAY"
echo -e "* cert-v2ray   : Renew Certificate V2RAY Account"
echo -e "=================================-VLESS-====================================="
echo -e "* add-vless    : Create V2RAY Vless Websocket Account"
echo -e "* del-vless    : Deleting V2RAY Vless Websocket Account"
echo -e "* renew-vless  : Extending Vless Account Active Life"
echo -e "* check-vless  : Check User Login V2RAY"

}

#Panel lsp
function panel-lsp() {
clear
echo -e "===============================-Panel lsp (L2TP, SSTP, PPTP)-================================"
echo -e "* add-vmess    : Create V2RAY Vmess Websocket Account"
echo -e "* del-vmess    : Deleting V2RAY Vmess Websocket Account"
echo -e "* renew-vmess  : Extending Vmess Account Active Life"
echo -e "* check-vmess  : Check User Login V2RAY"
echo -e "* cert-v2ray   : Renew Certificate V2RAY Account"
echo -e "=================================-VLESS-====================================="
echo -e "* add-vless    : Create V2RAY Vless Websocket Account"
echo -e "* del-vless    : Deleting V2RAY Vless Websocket Account"
echo -e "* renew-vless  : Extending Vless Account Active Life"
echo -e "* check-vless  : Check User Login V2RAY"

}

#Panel Wireguard
function panel-wg() {
clear
echo -e "===============================-Panel Wireguard-================================"
echo -e "* add-vmess    : Create V2RAY Vmess Websocket Account"
echo -e "* del-vmess    : Deleting V2RAY Vmess Websocket Account"
echo -e "* renew-vmess  : Extending Vmess Account Active Life"
echo -e "* check-vmess  : Check User Login V2RAY"
echo -e "* cert-v2ray   : Renew Certificate V2RAY Account"
echo -e "=================================-VLESS-====================================="
echo -e "* add-vless    : Create V2RAY Vless Websocket Account"
echo -e "* del-vless    : Deleting V2RAY Vless Websocket Account"
echo -e "* renew-vless  : Extending Vless Account Active Life"
echo -e "* check-vless  : Check User Login V2RAY"

}

#Panel Shadowsocks
function panel-ss() {
clear
echo -e "===============================-Panel Shadowsocks-================================"
echo -e "* add-vmess    : Create V2RAY Vmess Websocket Account"
echo -e "* del-vmess    : Deleting V2RAY Vmess Websocket Account"
echo -e "* renew-vmess  : Extending Vmess Account Active Life"
echo -e "* check-vmess  : Check User Login V2RAY"
echo -e "* cert-v2ray   : Renew Certificate V2RAY Account"
echo -e "=================================-VLESS-====================================="
echo -e "* add-vless    : Create V2RAY Vless Websocket Account"
echo -e "* del-vless    : Deleting V2RAY Vless Websocket Account"
echo -e "* renew-vless  : Extending Vless Account Active Life"
echo -e "* check-vless  : Check User Login V2RAY"

}