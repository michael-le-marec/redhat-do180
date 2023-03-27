lab troubleshoot-s2i start

source /usr/local/etc/ocp4.config

cd ~/DO180-apps
git checkout master

git checkout -b troubleshoot-s2i
git push -u origin troubleshoot-s2i

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-nodejs

cat ~/DO180/labs/troubleshoot-s2i/command.txt
oc new-app \
  --context-dir=nodejs-helloworld \
  https://github.com/${RHT_OCP4_GITHUB_USER}/DO180-apps#troubleshoot-s2i \
  -i nodejs:16-ubi8 --name nodejs-hello --build-env \
  npm_config_registry=http://${RHT_OCP4_NEXUS_SERVER}/repository/nodejs

oc get pods -w

oc get bc

oc logs bc/nodejs-hello

vim ~/DO180-apps/nodejs-helloworld/package.json

git commit -am "Fixed Express release"
git push

oc start-build bc/nodejs-hello
oc get pods -w

oc logs nodejs-hello-85cd76c99d-mgxxf

oc logs nodejs-hello-7679df8494-jxpms

oc expose svc/nodejs-hello

oc get route -o yaml

curl -w "\n" http://nodejs-hello-${RHT_OCP4_DEV_USER}-nodejs.${RHT_OCP4_WILDCARD_DOMAIN}

lab troubleshoot-s2i finish


oc get events


lab troubleshoot-container start

vi ~/DO180/labs/troubleshoot-container/conf/httpd.conf
cd ~/DO180/labs/troubleshoot-container/

podman build -t troubleshoot-container .

cd
podman images
podman run --name troubleshoot-container -d -p 10080:80 troubleshoot-container
podman logs -f troubleshoot-container
curl http://127.0.0.1:10080

lab troubleshoot-container finish

lab troubleshoot-review start

source /usr/local/etc/ocp4.config

ll
cd ..
cd DO180-apps
git checkout master
git checkout -b troubleshoot-review
git push -u origin troubleshoot-review

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-nodejs-app

oc new-app --name=nodejs-dev \
  https://github.com/${RHT_OCP4_GITHUB_USER}/DO180-apps#troubleshoot-review \
  -i nodejs:16-ubi8 \
  --context-dir=nodejs-app \
  --build-env \
  npm_config_registry=http://${RHT_OCP4_NEXUS_SERVER}/repository/nodejs

oc status
oc get pods
oc logs -f bc/nodejs-dev

vi nodejs-app/package.json
git commit -am "Updated package.json due to errors during build"
git push

oc start-build bc/nodejs-dev

oc logs -f bc/nodejs-dev

oc get pods
oc logs nodejs-dev-64889bc767-mj2h8

vi nodejs-app/server.js
git commit -am "Wrong module 'http-error' indicated. Changed to html-errors"
git push

oc start-build bc/nodejs-dev
oc expose svc nodejs-dev

oc get route

curl http://nodejs-dev-jkvjjx-nodejs-app.apps.eu410.prod.nextcle.com

oc logs -f deployment/nodejs-dev

sed -i 's/process.environment/process.env/g' nodejs-app/server.js
cat nodejs-app/server.js

git commit -am "Bug on process.environment corrected"
git push

cd

lab troubleshoot-review grade

lab troubleshoot-review finish
