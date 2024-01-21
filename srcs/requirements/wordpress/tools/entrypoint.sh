#!/bin/bash

echo "Inicio"
if [ ! -f "/var/www/html/wp-config.php" ]; then
	
	echo "entrou no if"
	#limpa completamente o /var/www/html antes da instalacao
	rm -rf *.*
	
	echo "passou 1"
	#faz o download do core do wordpress
	#wp core download --allow-root
	
	wget -q http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	mv wordpress/* .
	rm -rf latest.tar.gz wordpress

	echo "passou 2"
	#renomeia o wp-config.php
	mv wp-config-sample.php wp-config.php

	echo "passou 3"
	#faz as modificacoes com base nas envs com os dados personalizados para a instalacao do wordpress
	sed -i "s/database_name_here/$DATABASE_NAME/g" wp-config.php
	echo "passou 4a"
        sed -i "s/username_here/$DB_ADMIN_USER/g" wp-config.php
	echo "passou 4b"
        sed -i "s/password_here/$DB_ADMIN_PWD/g" wp-config.php
	echo "passou 4c"
        sed -i "s/localhost/$WP_HOST/g" wp-config.php
	echo "passou 4d"

	#instala o wordpress (cria um user admin no processo)
	wp core install --allow-root \
            --url=$DOMAIN_NAME \
            --title=$TITLE \
            --admin_user=$DB_ADMIN_USER \
            --admin_email=$DB_ADMIN_EMAIL \
            --admin_password=$DB_ADMIN_PWD \
            --skip-email

	echo "passou 5"
	#cria um novo usuario
	wp user create --allow-root $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --display_name=$WP_USER

	echo "passou 6"
	#Desinstala o plugins padrao akisme e hello do wordpress
	wp plugin uninstall akismet hello --allow-root

	echo "passou 7"
	#atualiza os plugins
        wp plugin update --all --allow-root

	echo "passou 8"
	#modifica o propietario e o grupo da pasta para www-data
        chown -R www-data:www-data /var/www/html

fi

echo "fim"
#inicializa o php-fpm
exec php-fpm7.4 -F
