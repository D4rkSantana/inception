FROM debian:bullseye

# Atualiza os repositorios, pacotes e instala o nginx e o openssl
RUN apt update -y && apt upgrade -y && apt install nginx -y && apt install openssl -y

# Cria a pasta e o certificado ssl
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -batch -x509 -sha256 -nodes -newkey rsa:2048 -days 365 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=BR/ST=SP/L=SP/O=42sp/CN=$DOMAIN_NAME/UID=esilva-s"
	# C -> pais | ST -> Estado | L -> Cidade | O -> Organizacao
	# CN -> Dominio | UID -> Usuario 

# Copia o arquivo com as configuracoes pre definidas do nginx
COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

#Abre a porta 443 do conteiner
EXPOSE 443

#Inicializa o nginx
CMD ["nginx", "-g", "daemon off;"]
