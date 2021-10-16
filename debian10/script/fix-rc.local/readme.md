# Fix rc.local

```
wget -O /etc/systemd/system/rc-local.service https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/fix-rc.local/rc-local.service && chmod +x /etc/systemd/system/rc-local.service
```
```
wget -O /etc/rc.local https://raw.githubusercontent.com/dsantos3526/SERVER/main/debian10/script/fix-rc.local/rc.local && chmod +x /etc/rc.local
```

* reboot system 
```
systemctl enable rc-local
systemctl start rc-local
systemctl status rc-local
```
