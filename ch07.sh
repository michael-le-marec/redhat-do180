lab multicontainer-design start

podman login registry.redhat.io
cat ~/DO180/labs/multicontainer-design/deploy/nodejs/Containerfile
ip -br addr list eth0

cat ~/DO180/labs/multicontainer-design/deploy/nodejs/nodejs-source/models/db.js

cat ~/DO180/labs/multicontainer-design/deploy/nodejs/build.sh

cd ~/DO180/labs/multicontainer-design/deploy/nodejs
./build.sh

podman images --format "table {{.ID}} {{.Repository}} {{.Tag}}"

vim ~/DO180/labs/multicontainer-design/deploy/nodejs/networked/run.sh

cd ~/DO180/labs/multicontainer-design/deploy/nodejs/networked
./run.sh

podman ps --format="table {{.ID}} {{.Names}} {{.Image}} {{.Status}}"

mysql -uuser1 -h 172.25.250.9 -pmypa55 -P 30306 items < ~/DO180/labs/multicontainer-design/deploy/nodejs/networked/db.sql

podman exec -it todoapi env

curl -w "\n" http://127.0.0.1:30080/todo/api/items/1

lab multicontainer-design finish

lab multicontainer-application start

source /usr/local/etc/ocp4.config
oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-application

vim ~/DO180/labs/multicontainer-application/todo-app.yml

cd ~/DO180/labs/multicontainer-application/

oc create -f todo-app.yml
oc get pods -w

mysql -uuser1 -pmypa55 -h 127.0.0.1 -P3306 items < db.sql

oc expose service todoapi

oc status | grep -o "http:.*com"

curl -w "\n" $(oc status | grep -o "http:.*com")/todo/api/items/1

cd
lab multicontainer-application finish

oc get templates -n openshift


lab multicontainer-openshift start

source /usr/local/etc/ocp4.config

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-template

vim ~/DO180/labs/multicontainer-openshift/todo-template.json

cd ~/DO180/labs/multicontainer-openshift
oc process -f todo-template.json | oc create -f -

oc get pods -w

oc port-forward mysql 3306:3306

mysql -uuser1 -pmypa55 -h 127.0.0.1 -P3306 items < db.sql

oc expose service todoapi

oc status | grep -o "http:.*com"

curl -w "\n" $(oc status | grep -o "http:.*com")/todo/api/items/1

lab multicontainer-openshift finish


lab multicontainer-review start

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-deploy

cat ~/DO180/labs/multicontainer-review/images/mysql/Containerfile
cd  ~/DO180/labs/multicontainer-review/images/mysql/

podman login registry.redhat.io
podman login quay.io

podman build -t do180-mysql-80-rhel8 .

podman images

podman tag do180-mysql-80-rhel8 quay.io/michael_lemarec/do180-mysql-80-rhel8
podman push do180-mysql-80-rhel8 quay.io/michael_lemarec/do180-mysql-80-rhel8

podman images

cd ../quote-php

podman build -t do180-quote-php .
podman tag do180-quote-php quay.io/michael_lemarec/do180-quote-php
podman push do180-quote-php quay.io/michael_lemarec/do180-quote-php

cd ../..

vim quote-php-template.json

oc create -f quote-php-template.json

oc process quote-php-persistent -p RHT_OCP4_QUAY_USER=michael_lemarec > quote-php.json

oc create -f quote-php.json

oc get pods -w

oc expose service quote-php

oc get service

oc get routes

curl quote-php-jkvjjx-deploy.apps.eu410.prod.nextcle.com

lab multicontainer-review grade

lab multicontainer-review finish

