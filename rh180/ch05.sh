lab dockerfile-create start

vim ~/DO180/labs/dockerfile-create/Containerfile

FROM ubi8/ubi:8.5

MAINTAINER Michaël Le Marec <michael.lemarec@ibm.com>

LABEL description="A custom Apache container based on UBI 8"

RUN yum install -y httpd && yum clean all

RUN echo "Hello from Containerfile" > /var/www/html/index.html

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]


cd ~/DO180/labs/dockerfile-create
podman build --layers=false -t do180/apache .
podman images
podman run --name lab-apache -d -p 10080:80 do180/apache
podman ps

curl -s localhost:10080

lab dockerfile-create finish

# LAB
lab dockerfile-review start


FROM ubi8/ubi:8.5

MAINTAINER Michaël Le Marec <michael.lemarec@ibm.com>

ENV PORT 8080

RUN yum install httpd && yum clean all

RUN sed -ri -e "/^Listen 80/c\Listen ${PORT}" /etc/httpd/conf/httpd.conf && \
    chown -R apache:apache /etc/httpd/logs/ && \
    chown -R apache:apache /run/httpd/

USER apache

# Expose the custom port that you provided in the ENV var
EXPOSE ${PORT}

# Copy all files under src/ folder to Apache DocumentRoot (/var/www/html)
COPY ./src/ /var/www/html/

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]

podman build --layers=false -t do180/custom-apache .

podman run -d --name containerfile -p 20080:8080 \
    do180/custom-apache

curl -s localhost:20080

lab dockerfile-review grade
lab dockerfile-review finish

