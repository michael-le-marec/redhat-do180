lab image-operations start

podman login quay.io
podman run -d --name official-httpd \
    -p 8180:80 quay.io/redhattraining/httpd-parent

podman exec -it official-httpd /bin/bash
echo "DO180 Page" > /var/www/html/do180.html
exit
curl 127.0.0.1:8180/do180.html
podman diff official-httpd
podman stop official-httpd
podman commit -a 'Michael' official-httpd do180-custom-httpd
podman images

source /usr/local/etc/ocp4.config
podman tag do180-custom-httpd \
    quay.io/${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0

podman push quay.io/${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0
podman pull quay.io/${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0
podman images

podman run -d --name test-httpd -p 8280:80 \
    ${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0

curl http://localhost:8280/do180.html

lab image-operations finish

# LAB
lab image-review start
podman pull quay.io/redhattraining/nginx:1.17
podman images
podman run --name official-nginx -d -p 8080:80 \
    quay.io/redhattraining/nginx:1.17
podman ps
podman exec -it official-nginx /bin/bash
echo "DO180" > /usr/share/nginx/html/index.html
exit
curl localhost:8080

podman stop official-nginx
podman commit -a 'Michael' official-nginx do180/mynginx:v1.0-SNAPSHOT
podman images

podman run -d --name official-nginx-dev -p 8080:80 \
    do180/mynginx:v1.0-SNAPSHOT

curl localhost:8080
podman exec -it official-nginx-dev /bin/bash
echo "DO180 Page" > /usr/share/nginx/html/index.html
exit

podman stop official-nginx-dev
podman commit -a 'Michael' official-nginx-dev do180/mynginx:v1.0

podman rmi -f do180/mynginx:v1.0-SNAPSHOT
podman ps -a

podman run -d --name my-nginx -p 8280:80 do180/mynginx:v1.0
curl localhost:8280

lab image-review grade
lab image-review finish


