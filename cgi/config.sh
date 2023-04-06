#!/bin/bash
DB_USER="basher"
DB_PASSWORD="dbpassword_changeme"
DB_DATABASE="basher"
DB_COMMAND="mysql -u $DB_USER -p$DB_PASSWORD $DB_DATABASE"
DEFAULT_ADMIN_LOGIN="admin"
DEFAULT_ADMIN_PASSWORD="admin"

PAGE_URL="http://localhost:8080"

if [[ `echo "show tables;" | $DB_COMMAND | wc -l` -eq 0 ]]; then
	echo "create table if not exists users (id int auto_increment not null primary key, login varchar(32) unique key not null, password varchar(128) not null, admin int(1) DEFAULT 0 not null);" | $DB_COMMAND > /dev/null
	echo "insert into users (login, password, admin) values ('$DEFAULT_ADMIN_LOGIN', '`echo $DEFAULT_ADMIN_LOGIN:$DEFAULT_ADMIN_PASSWORD | sha512sum | awk '{print $1}'`', '1');" | $DB_COMMAND > /dev/null
	echo "create table if not exists posts (id int auto_increment not null primary key, login varchar(32), title varchar(32) not null, content varchar(600) not null, time datetime default now() not null);" | $DB_COMMAND > /dev/null
	echo "create table if not exists comments (id int auto_increment not null primary key, login varchar(32), content varchar(100) not null, time datetime default now() not null);" | $DB_COMMAND > /dev/null
fi
