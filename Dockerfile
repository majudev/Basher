FROM debian:bullseye-slim

EXPOSE 8080

RUN apt update && \
	apt dist-upgrade -y && \
	apt install -y \
	apache2 \
	mariadb-client \
	mariadb-server \
	gpg \
	sudo \
	base58

COPY cgi /var/www/cgi
COPY basher.conf /etc/apache2/sites-available
COPY start.sh /app.sh

RUN	a2enmod cgid && \
	sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf && \
	rm /etc/apache2/sites-enabled/* && \
	a2ensite basher

CMD ["/app.sh"]
