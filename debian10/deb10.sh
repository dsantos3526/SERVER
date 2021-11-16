#!/bin/bash
# Diyan Santoso
# initialisasi var

#Os
os=`uname -m`
echo "$os"
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
sleep


#Cek IP
myip=$(wget -qO- icanhazip.com);
echo "IP Public Anda : $myip"
sleep 2


#Cek file dan Jka tidak ada akan membuat file
a=/root/ip.txt
if [[ -f "$a" ]]
then
    echo "$a Sudah Ada File nya"
fi
if [[ ! -f $a ]]
then
  touch /root/ip.txt
  echo "$myip" > /root/ip.txt
fi

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local


#Update && Upgrade Debian
apt-get update --allow-releaseinfo-change
apt-get -y update && apt-get -y upgrade
cd

sleep 2
clear
apt-get install wget curl
echo "TimeZone GMT +7"
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
clear
sleep 2

#Installl Package
apt-get -y install nano iptables openssl dnsutils openvpn screen whois ngrep unzip neofetch ufw vnstat

echo "Memulai Install Nginx"
apt-get -y install nginx
clear
echo "Nginx Selesai di install"
sleep 2

cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Diyan Santoso</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf  "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/ssl.tar"
cd /etc/openvpn/
tar xf openvpn.tar
rm -f /etc/openvpn/openvpn.tar
wget -O /etc/openvpn/server.conf "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/server.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 9.9.9.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_set.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/client.conf"
sed -i 's/xxx/'$myip'/g' /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

#cek rc.local
a=/etc/rc.local

if [[ -f "$a" ]]
then
    echo "$a Sudah Ada"
fi
if [[ ! -f $a ]]
then
    clear
    echo "$a Not Installed"
    wget -O /etc/systemd/system/rc-local.service https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/fix-rc.local/rc-local.service && chmod +x /etc/systemd/system/rc-local.service
    wget -O /etc/rc.local https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/fix-rc.local/rc.local && chmod +x /etc/rc.local
    systemctl enable rc-local
    systemctl start rc-local
fi

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/badvpn-udpgw"
if [ "$os" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting ssh
cd

echo "Port 22" >> /etc/ssh/sshd_config
echo "Port 234" >> /etc/ssh/sshd_config
echo "PermitRootLogin Yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication Yes" >> /etc/ssh/sshd_config
echo "Banner /etc/banner.txt" >> /etc/ssh/sshd_config

service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=222/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 444"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart
sleep 2
#config stunnel
apt-get -y install stunnel4
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[ssh]
accept = 443
connect = 127.0.0.1:444

END


#stunnel4
echo "=================  membuat Sertifikat OpenSSL ======================"
echo "========================================================="
#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=ID/ST=BALI/L=BADUNG/O=GTG-COMPUTER/OU=GTG-COMPUTER/CN=GTGCOMPUTER/emailAddress=ADMIN@GTGCOMPUTER.MY.ID"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart
sleep 2
# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid
cd
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10//script/squid.conf"
#Sent IP
sed -i 's/xxx/'$myip'/g' /etc/squid/squid.conf
service squid restart

# blockir torrent
iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A OUTPUT -p udp --dport 1024:65534 -j DROP
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP


# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10//script/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/ddos-deflate-master.zip

# setting banner
rm /etc/banner.txt
wget -O /etc/banner.txt "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/banner.txt"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner.txt"@g' /etc/default/dropbear
service ssh restart
service dropbear restart


#Install Websocket
wget https://github.com/dsantos3526/SERVER/blob/main/debian10/script/websocket/install-ws.sh
chmod +x isntall-ws.sh
bash install-ws.sh
rm -f install-ws.sh

#ufw
sudo ufw enabled
sudo ufw allow 443 comment "Stunnel"
sudo ufw allow 1194 comment "Openvpn"
sudo ufw allow 80 comment "Http"
sudo ufw allow 22 comment "SSH OPenssh"
sudo ufw allow 81 comment "Nginx"
sudo ufw allow 222 comment "Dropbear"
sudo ufw allow 444 comment "Dropbear"
sudo ufw enable




##Download Script
cd /usr/bin
wget -O /usr/bin/menu https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/menu
wget -O /usr/bin/add https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/add
wget -O /usr/bin/trial https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/trial
wget -O /usr/bin/del https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/del
wget -O /usr/bin/list https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/list
wget -O /usr/bin/cek https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/cek
wget -O /usr/bin/del_ex https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/del_ex
wget -O /usr/bin/speedtest https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/speedtest.py
wget -O /usr/bin/info https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/info
wget -O /usr/bin/about https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/about
wget -O /usr/bin/about https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/domain
echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x /usr/bin/menu
chmod +x /usr/bin/add
chmod +x /usr/bin/trial
chmod +x /usr/bin/del
chmod +x /usr/bin/list
chmod +x /usr/bin/cek
chmod +x /usr/bin/del_ex
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/info
chmod +x /usr/bin/about
chmod +x /usr/bin/domain

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service stunnel4 restart
service squid restart
service fail2ban restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile
clear


# info    
echo "**********************************************************************"
echo "*********************** Autoscript GTG COMPUTER **********************" | tee log-install.txt
echo "**********************************************************************" | tee -a log-install.txt
echo "*************************** SSH WS & OPENVPN *************************" | tee -a log-install.txt
echo "**********************************************************************" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "----------------------------------------------------------------------"  | tee -a log-install.txt
echo "    -  OpenSSH             : 22, 234"  | tee -a log-install.txt
echo "    -  Dropbear            : 222, 444"  | tee -a log-install.txt
echo "    -  OpenSSH WS          : 80 "  | tee -a log-install.txt
echo "    -  SSL                 : 443"  | tee -a log-install.txt
echo "    -  Squid               : 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "    -  OpenVPN             : TCP 1194 (client config : http://$myip:81/client.ovpn)"  | tee -a log-install.txt
echo "    -  badvpn              : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "    -  nginx               : 81"  | tee -a log-install.txt
echo "    -  "  | tee -a log-install.txt
echo "    -  Script"  | tee -a log-install.txt
echo "    -  ------"  | tee -a log-install.txt
echo "    -  menu           (Menampilkan daftar perintah yang tersedia)"  | tee -a log-install.txt
echo "    -  add            (Membuat Akaun SSH)"  | tee -a log-install.txt
echo "    -  trial          (Membuat Akaun Trial)"  | tee -a log-install.txt
echo "    -  del            (Menghapus Akaun SSH)"  | tee -a log-install.txt
echo "    -  cek            (Cek User Login)"  | tee -a log-install.txt
echo "    -  list           (Cek Member SSH)"  | tee -a log-install.txt
echo "    -  del_ex         (Delete User expired)"  | tee -a log-install.txt
#echo     -  "resvis        (Restart Service Dropbear, Squid, OpenVPN dan SSH)"  | tee -a log-install.txt
echo "    -  reboot         (Reboot VPS)"  | tee -a log-install.txt
echo "    -  speedtest      (Speedtest VPS)"  | tee -a log-install.txt
echo "    -  info           (Menampilkan Informasi Sistem)"  | tee -a log-install.txt
echo "    -  "  | tee -a log-install.txt
echo "    -  Fitur lain"  | tee -a log-install.txt
echo "    -  -----------------------------------------------------------------"  | tee -a log-install.txt
echo "    -  Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "    -  IPv6     : [off]"  | tee -a log-install.txt
echo "    -  "  | tee -a log-install.txt
echo "    -  Thanks To"  | tee -a log-install.txt
echo "    -  -----------------------------------------------------------------"  | tee -a log-install.txt
echo "    -  Allah"  | tee -a log-install.txt
echo "    -  Google"  | tee -a log-install.txt
echo "    -  "  | tee -a log-install.txt
echo "    -  VPS AUTO REBOOT SETIAP JAM 00.00 WIB"  | tee -a log-install.txt
echo "    -  Log Installation --> /root/log-install.txt"  | tee -a log-install.txt
echo "    -  "  | tee -a log-install.txt
echo "==========================================================================="  | tee -a log-install.txt
cd
rm -f /root/deb10.sh
