#!/bin/bash
#auto install debian
#created by Diyan Santoso

# Informasi
country=ID
state=BALI
locality=BADUNG
organization=GTG_COMPUTER
organizationalunit=SERVER_GTG
commonname=GTGCOMPUTER.MY.ID
email=ADMIN@GTGCOMPUTER.MY.ID

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[dropbear]
accept = 443
connect = 127.0.0.1:143
[dropbear]
accept = 222
connect = 127.0.0.1:22
[dropbear]
accept = 444
connect = 127.0.0.1:44
[dropbear]
accept = 777
connect = 127.0.0.1:77
END

echo "=================  membuat Sertifikat OpenSSL ======================"
echo "========================================================="
#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

#hapus auto install stunnel debian
rm -rf stunnel.sh
