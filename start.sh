echo "root:$PASSWORD" |chpasswd
echo "$PASSWORD\n$PASSWORD" | smbpasswd -s -a "root"
htpasswd -cb /etc/apache2/webdav.password root $PASSWORD
chown root:www-data /etc/apache2/webdav.password
chmod 640 /etc/apache2/webdav.password

cd /WebSSH2 && npm start&
smbd -FS&
cd / && /usr/sbin/sshd -D&
UID=1000
GID=1000
droppy start -c /droppy/config -f /mount&
echo "adding"
droppy add root $PASSWORD p  -c /droppy/config -f /mount
echo "added"
apache2 -D FOREGROUND