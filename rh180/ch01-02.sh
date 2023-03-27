cat <<EOF > token
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
EOF

# store credentials in cache memory for future use
git config --global credential.helper cache

# Configure the workstation machine
lab-configure

git clone https://github.com/michael-le-marec/DO180-apps.git
git checkout -b testbranch

echo "DO180" > TEST
git add .
git commit -m "DO180"

git push --set-upstream origin testbranch

podman search rhel
podman pull rhel
podman images
podman run ubi8/ubi:8.3 echo 'Hello World!'

podman login registry.redhat.io


podman run -d -p 8080 registry.redhat.io/rhel8/httpd-24
podman port -l # -l >> latest (no need to enter container ID)
curl http://0.0.0.0:44389

podman run -it ubi8/ubi:8.3 /bin/bash

podman run -e GREET=Hello -e NAME=RedHat ubi8/ubi:8.3 printenv GREET NAME

podman run --name mysql-custom \
 -e MYSQL_USER=redhat -e MYSQL_PASSWORD=r3dh4t \
 -e MYSQL_ROOT_PASSWORD=r3dh4t \
 -d registry.redhat.io/rhel8/mysql-80

lab container-create start
podman login registry.redhat.io

podman run --name mysql-basic \
 -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
 -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
 -d registry.redhat.io/rhel8/mysql-80:1

podman exec -it mysql-basic /bin/bash
mysql -u root
SHOW DATABASES;
USE items;

CREATE TABLE Projects (id int NOT NULL,
  name varchar(255) DEFAULT NULL,
  code varchar(255) DEFAULT NULL,
  PRIMARY KEY (id));

SHOW TABLES;

INSERT INTO Projects (id, name, code) VALUES (1, 'DevOps', 'DO180');

SELECT * FROM Projects;
exit
exit
lab container-create finish

# Exploring Root and Rootless Containers
lab container-rootless start

sudo podman run --rm --name asroot -it \
  registry.access.redhat.com/ubi8:latest /bin/bash

whoami
id
sleep 1000
# new terminal
sudo ps -ef | grep "sleep 1000"

podman run --rm --name asuser -it \
  registry.access.redhat.com/ubi8:latest /bin/bash

# exercise
podman run --name httpd-basic -d -p 8080:80 quay.io/redhattraining/httpd-parent:2.4
podman ps
curl 0.0.0.0:8080
podman exec -it httpd-basic /bin/bash

