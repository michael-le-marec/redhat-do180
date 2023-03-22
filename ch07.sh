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

