
# Define a imagem base
FROM	debian:bullseye

#Atualiza os repositorios e pacotes e instala o mariadb
RUN	apt update -y && apt upgrade -y && \
	apt install mariadb-server -y

#Cria os diretorios para o mysql e concede as permisoes
RUN 	mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
	chmod 777 -R /var/run/mysqld /var/lib/mysql

#copia o arquivo de configuracao para o mariadb
COPY	./conf/my.cnf /etc/mysql/mariadb.conf.d/
#copia o script
COPY	./tools/entrypoint.sh /usr/local/bin/

#modifica as permissoes para o arquivo de config do mariadb
#concede permissao de execucao para o script
RUN	chmod 644 /etc/mysql/mariadb.conf.d/my.cnf && \
	chmod +x /usr/local/bin/entrypoint.sh

#abre a porta 3306 do conteiner
EXPOSE 3306

#Define o usuario mysql como o padrão
USER mysql

#executa o script
ENTRYPOINT ["entrypoint.sh"]
