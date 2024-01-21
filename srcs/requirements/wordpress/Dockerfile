#Imagem base
FROM debian:bullseye

#Define no debian a nao interacao com o usuario
ENV DEBIAN_FRONTEND=noninteractive

#Atualiza os repositorios e os pacotes
#Instala o PHP e alguns modulos para o funcionamento do Wordpress
#Instala o wget e o cliente do mariadb
RUN	apt update && apt upgrade -y && \
	apt install -y php7.4 php7.4-fpm \
	php7.4-cli php7.4-curl php7.4-mysql \
	php7.4-mbstring php7.4-xml php7.4-gd \
	wget mariadb-client

#Faz o Download do wp-cli e a sua instalacao
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	--output-document=/usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp

#cria e concede permissoes para o diretorio de trabalho 
RUN	mkdir -p /run/php /var/www/html && \
	chmod -R 755 /var/www/html

#Copia o arquivo de configuração do php-fpm e define as permissoes
COPY	./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN	chmod 755 /etc/php/7.4/fpm/pool.d/www.conf

#define o diretorio de trabalho
WORKDIR	/var/www/html

#Copia o script de instalação do wordpress
COPY	./tools/entrypoint.sh /usr/local/bin

#Concede permissoes para e para o script
RUN	chmod +x /usr/local/bin/entrypoint.sh

#Abre a porta 9000 do conteiner
EXPOSE	9000

#Executa o script de instalacao do wordpress
ENTRYPOINT ["entrypoint.sh"]
