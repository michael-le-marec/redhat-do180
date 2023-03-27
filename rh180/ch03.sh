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

mkdir /home/student/dbfiles
podman unshare chown -R 27:27 /home/student/dbfiles
sudo restorecon -Rv /home/student/dbfiles
podman run -v /home/student/dbfiles:/var/lib/mysql rhmap47/mysql

lab manage-storage start
mkdir -vp /home/student/local/mysql
sudo semanage fcontext -a -t \
    container_file_t '/home/student/local/mysql(/.*)?'
sudo restorecon -R /home/student/local/mysql
ls -ldZ /home/student/local/mysql
podman unshare chown 27:27 /home/student/local/mysql
podman pull registry.redhat.io/rhel8/mysql-80:1
podman run --name persist-db \
 -d -v /home/student/local/mysql:/var/lib/mysql/data \
 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
 registry.redhat.io/rhel8/mysql-80:1
podman ps --format="{{.ID}} {{.Names}} {{.Status}}"

ls -ld /home/student/local/mysql/items
podman unshare ls -ld /home/student/local/mysql/items
podman ps -a
podman exec -it persist-db /bin/bash
cat /etc/passwd

lab manage-storage finish

podman run -d --name apache1 -p 8080:8080 registry.redhat.io/rhel8/httpd-24
podman run -d --name apache2 -p 127.0.0.1:8081:8080 registry.redhat.io/rhel8/httpd-24
podman port apache3
podman run -d --name apache3 -p 127.0.0.1::8080 registry.redhat.io/rhel8/httpd-24
curl -s 127.0.0.1:39739 | egrep '</?title>'
podman run -d --name apache4 -p 8080 registry.redhat.io/rhel8/httpd-24
podman port apache4
podman rm -a -f
podman ps -a

lab manage-networking start
podman run --name mysqldb-port -d \
    -v /home/student/local/mysql:/var/lib/mysql/data \
    -p 13306:3306 \
    -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
    -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
    registry.redhat.io/rhel8/mysql-80:1
podman ps --format="{{.ID}} {{.Names}} {{.Ports}}"
podman ps -a
podman start fde
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P 13306 \
    items < /home/student/DO180/labs/manage-networking/db.sql
podman exec -it mysqldb-port mysql -uroot items -e "SELECT * FROM Item"
lab manage-networking finish

lab manage-review start
mkdir -vp /home/student/local/mysql
sudo semanage fcontext -a -t container_file_t '/home/student/local/mysql(/.*)?'
sudo restorecon -R /home/student/local/mysql
podman unshare chown -Rv 27:27 /home/student/local/mysql

podman login registry.redhat.io
podman run -d --name mysql-1 \
    -v /home/student/local/mysql:/var/lib/mysql/data \
    -p 13306:3306 \
    -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
    -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
    registry.redhat.io/rhel8/mysql-80:1

mysql -uuser1 -pmypa55 -h 127.0.0.1 -P 13306 \
    items < /home/student/DO180/labs/manage-review/db.sql

mysql -uuser1 -pmypa55 -h 127.0.0.1 -P 13306 \
    items -e "SELECT * FROM Item"

podman stop mysql-1

podman run -d --name mysql-2 \
    -v /home/student/local/mysql:/var/lib/mysql/data \
    -p 13306:3306 \
    -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
    -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
    registry.redhat.io/rhel8/mysql-80:1

podman ps -a > /tmp/my-containers
cat /tmp/my-containers
mysql -uuser1 -pmypa55 -h 127.0.0.1 -P 13306 \
    items -e "SELECT * FROM Item"

mysql -uuser1 -pmypa55 -h 127.0.0.1 -P 13306 \
    items -e "SELECT * FROM Item"