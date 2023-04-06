#!/bin/bash
service apache2 start
service mariadb start
if [[ `cat /var/www/cgi/config.sh | grep -c dbpassword_changeme` -gt 0 ]]; then
	PASSWORD="`tr -dc A-Za-z0-9 </dev/urandom | head -c 66 ; echo ''`"
	echo "CREATE USER basher@localhost IDENTIFIED BY '$PASSWORD'; CREATE DATABASE basher; GRANT ALL PRIVILEGES ON basher.* TO basher@localhost;" | mysql
	sed -i 's/dbpassword_changeme/'"$PASSWORD"'/g' /var/www/cgi/config.sh
fi
if ! [ -d /var/www/.gnupg ]; then
	mkdir /var/www/.gnupg
	chown www-data:www-data /var/www/.gnupg
	chmod 700 /var/www/.gnupg
fi
if [[ `sudo -u www-data gpg --list-secret-keys | wc -l` -eq 0 ]]; then
	cat >/recipe <<EOF
     %echo generating new GPG key
     %no-protection
     Key-Type: RSA
     Key-Length: 4096
     Subkey-Type: RSA
     Subkey-Length: 4096
     Name-Real: Basher Authman
     Name-Email: root@basher
     Expire-Date: 0
     %commit
     %echo done
EOF
	sudo -u www-data gpg --batch --generate-key /recipe
fi

while true; do
	sleep 100
done
