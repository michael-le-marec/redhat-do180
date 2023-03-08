podman run registry.redhat.io/rhel8/httpd-24
podman ps
podman run --name my-httpd-container -d registry.redhat.io/rhel8/httpd-24
podman run registry.redhat.io/rhel8/httpd-24 ls /tmp
podman run -it registry.redhat.io/rhel8/httpd-24 /bin/bash
podman run -d registry.redhat.io/rhel8/httpd-24
podman top 001
podman ps
podman exec 001 cat /etc/hostname
podman exec -l cat /etc/hostname
podman ps
podman ps -a
podman stop my-httpd-container
podman kill -s SIGKILL my-httpd-container
podman restart my-httpd-container
podman rm my-httpd-container
podman stop -a
podman rm -a
podman ps -a

lab manage-lifecycle start
podman login registry.redhat.io
podman run --name mysql-db registry.redhat.io/rhel8/mysql-80:1
podman run --name mysql -d \
    -e MYSQL_USER=user1 \
    -e MYSQL_PASSWORD=mypa55 \
    -e MYSQL_DATABASE=items \
    -e MYSQL_ROOT_PASSWORD=r00tpa55 \
    registry.redhat.io/rhel8/mysql-80:1
podman ps
podman cp ~/DO180/labs/manage-lifecycle/db.sql mysql:/
podman exec mysql /bin/bash -c 'mysql -uuser1 -pmypa55 items < /db.sql'
podman run --name mysql-2 -it registry.redhat.io/rhel8/mysql-80:1 /bin/bash
mysql -uroot
exit
podman ps -a
podman exec mysql /bin/bash -c 'mysql -uuser1 -pmypa55 -e "select * from items.Projects;"'
lab manage-lifecycle finish

