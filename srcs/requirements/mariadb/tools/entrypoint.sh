#!/bin/bash

#incializa o mariadb em segundo plano
#mysqld_safe --slip-syslog &
service mariadb start

echo "passo1"
# Espera até que o MariaDB esteja pronto
while ! mysqladmin ping -hlocalhost --silent; do
	sleep 1
done

echo "passo2"

#Caso a não exista a base de dados, ele cria a base e cria um usuario
#case ja exista, ele avisa com um echo
if ! mysql -e "USE $DATABASE_NAME;";

then
	echo "c1"
	mysql -e "CREATE DATABASE $DATABASE_NAME;"
	echo "c2"
	mysql -e "CREATE USER '$DB_ADMIN_USER'@'%' IDENTIFIED BY '$DB_ADMIN_PWD';"
	echo "c3"
	mysql -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DB_ADMIN_USER'@'%';"
	echo "c4"
	mysql -e "FLUSH PRIVILEGES;"
	echo "c5"

	echo "Database created."
else
	echo "Database '$DATABASE_NAME' has already been created"
fi

echo "passo 3"
#desliga o banco
kill $(cat /var/run/mysqld/mysqld.pid)

echo "passo 4"
#religa o banco de modo que o conteiner permanessa ativo apos o fim do script
#exec mariadbd
mysqld
