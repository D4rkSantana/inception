#!/bin/bash

#incializa o mariadb em segundo plano
echo "= Inicio do script"
mysqld_safe --skip-syslog &
echo "= Inicialização do MariaDB"

# Espera até que o MariaDB esteja pronto
while ! mysqladmin ping -hlocalhost --silent; do
	sleep 1
done

echo "= Inicializacao completa do MariaDB"

#Caso a não exista a base de dados, ele cria a base e cria um usuario
#case ja exista, ele avisa com um echo
if ! mysql -e "USE $DATABASE_NAME;";

then
	echo "= Criacao de um novo Database"
	mysql -e "CREATE DATABASE $DATABASE_NAME;"
	mysql -e "CREATE USER '$DB_ADMIN_USER'@'%' IDENTIFIED BY '$DB_ADMIN_PWD';"
	mysql -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DB_ADMIN_USER'@'%';"
	mysql -e "FLUSH PRIVILEGES;"

	echo "= Criacao completa do Database"
else
	echo "= Database '$DATABASE_NAME' ja existe"
fi

echo "= Desligamento do banco"
#desliga o banco
kill $(cat /var/run/mysqld/mysqld.pid)

echo "= Religamento do banco"
#religa o banco de modo que o conteiner permanessa ativo apos o fim do script
exec mysqld
