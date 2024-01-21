#!/bin/bash

echo "Inicio"
if [ ! -f "/var/www/html/wp-config.php" ]; then

	#limpa completamente o /var/www/html antes da instalacao
	rm -rf *.*

	echo "= Inicio do download do Wordpress"
	#faz o download do core do wordpress
	wp core download --allow-root
	echo "= Download concluido"

	#renomeia o wp-config.php
	mv wp-config-sample.php wp-config.php
	echo "= wp-config.php renomeado"

	#faz as modificacoes com base nas envs com os dados personalizados para a instalacao do wordpress
	sed -i "s/database_name_here/$DATABASE_NAME/g" wp-config.php
        sed -i "s/username_here/$DB_ADMIN_USER/g" wp-config.php
        sed -i "s/password_here/$DB_ADMIN_PWD/g" wp-config.php
        sed -i "s/localhost/$WP_HOST/g" wp-config.php
	echo "= alteracoes no wp-config.php"

	#instala o wordpress (cria um user admin no processo)
	wp core install --allow-root \
            --url=$DOMAIN_NAME \
            --title=$TITLE \
            --admin_user=$DB_ADMIN_USER \
            --admin_email=$DB_ADMIN_EMAIL \
            --admin_password=$DB_ADMIN_PWD \
            --skip-email
	echo "= Instalacao do Wordpress"

	#cria um novo usuario
	wp user create --allow-root $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --display_name=$WP_USER
	echo "= Criacao de um novo usuario"

	#Desinstala o plugins padrao akisme e hello do wordpress
	wp plugin uninstall akismet hello --allow-root
	echo "= Desinstalados plugins akismet e hello"

	#atualiza os plugins
        wp plugin update --all --allow-root
	echo "= Atualizacao dos plugins"

	#modifica o propietario e o grupo da pasta para www-data
        chown -R www-data:www-data /var/www/html
	echo "= Modificacao nos proprietatios e grupo do /var/www/html"

fi

echo "== Configuracao Finalizada"
#inicializa o php-fpm
exec php-fpm7.4 -F
