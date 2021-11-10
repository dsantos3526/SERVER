#!/bin/bash

echo -e "[*][*][*]======================================[*][*][*]"  | lolcat
echo -e "                                                  "        | lolcat
echo -e "            Panel Utama GTG COMPUTER"                      | lolcat
echo -e "                                                          "| lolcat
echo -e "    [1] Panel SSH"                      | lolcat
echo -e "    [2] Panel V2ray"                      | lolcat
echo -e "    [3] Panel "                     | lolcat
echo -e "    [4] More Options"| lolcat
echo -e "    [x] menu"| lolcat
echo -e "                                                   "| lolcat
read -p "      Select From Options [1-4 or x] :  " vvt
echo -e "                                                   "| lolcat
echo -e "[*][*][*]======================================[*][*][*]"| lolcat
clear
case $vvt in

1)
add-ws
;;
2)
add-vless
;;
3)
add-tr
;;
4)
options
;;
x)
menu
;;
*)
echo "Please enter an correct number"
;;
esac