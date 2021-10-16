#!/bin/bash
# Diyan Santoso
# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

sudo su
cd

apt-get -y update && apt-get -y upgrade
apt-get install wget curl

ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

apt-get -y install nginx

apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip neofetch

cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/kholizsivoi/script/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Diyan Santoso</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/kholizsivoi/script/master/vps.conf"
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
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

#cek rc.local
a=/etc/rc.local

if [[ -f "$a" ]]
then
    echo "$a Already Installed"
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
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=444/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 444 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart




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

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid
cd
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10//script/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
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

##Download Script
wget -O /usr/bin/menu https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/menu && chmod +x menu
wget -O /usr/bin/add https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/add && chmod +x add
wget -O /usr/bin/trial https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/trial && chmod +x trial
wget -O /usr/bin/del https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/del && chmod +x del
wget -O /usr/bin/list https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/list && chmod +x list
wget -O /usr/bin/cek https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/cek && chmod +x cek
wget -O /usr/bin/del_ex https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/del_ex && chmod +x del_ex
wget -O /usr/bin/speedtest https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/speedtest.PY && chmod +x speedtest
wget -O /usr/bin/info https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/info && chmod +x info
wget -O /usr/bin/about https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/menu/about && chmod +x about

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service stunnel4 restart
service squid3 restart
service fail2ban restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile
clear


# info
echo "***Diyan Santoso***"
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 80, 444"  | tee -a log-install.txt
echo "SSL      : 443"  | tee -a log-install.txt
echo "Squid3   : 8080, 3128 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu          (Menampilkan daftar perintah yang tersedia)"  | tee -a log-install.txt
echo "add           (Membuat Akaun SSH)"  | tee -a log-install.txt
echo "trial         (Membuat Akaun Trial)"  | tee -a log-install.txt
echo "del           (Menghapus Akaun SSH)"  | tee -a log-install.txt
echo "cek           (Cek User Login)"  | tee -a log-install.txt
echo "list          (Cek Member SSH)"  | tee -a log-install.txt
echo "del_ex        (Delete User expired)"  | tee -a log-install.txt
#echo "resvis       (Restart Service Dropbear, Webmin, Squid3, OpenVPN dan SSH)"  | tee -a log-install.txt
echo "reboot       (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest    (Speedtest VPS)"  | tee -a log-install.txt
echo "info         (Menampilkan Informasi Sistem)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Thanks To"  | tee -a log-install.txt
echo "---------"  | tee -a log-install.txt
echo "Allah"  | tee -a log-install.txt
echo "Google"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT SETIAP JAM 00.00 WIB"  | tee -a log-install.txt
echo "Log Installation --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/deb10.sh


