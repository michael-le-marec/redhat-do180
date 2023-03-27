lab openshift-resources start

source /usr/local/etc/ocp4.config

oc login -u ${RHT_OCP4_DEV_USER} \
    -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API} 

oc new-project ${RHT_OCP4_DEV_USER}-mysql-openshift

oc new-app --template=mysql-persistent \
    -p MYSQL_USER=user1 -p MYSQL_PASSWORD=mypa55 -p MYSQL_DATABASE=testdb \
    -p MYSQL_ROOT_PASSWORD=r00tpa55 -p VOLUME_CAPACITY=10Gi

oc status
oc get pods
oc describe pod mysql-1-xbzc4
oc get svc
oc describe svc mysql | less
oc get pvc
oc describe pvc/mysql | less

oc port-forward mysql-1-xbzc4 3306:3306
mysql -uuser1 -pmypa55 --protocol tcp -h localhost
SHOW DATABASES;
exit

oc delete project ${RHT_OCP4_DEV_USER}-mysql-openshift
lab openshift-resources finish

lab openshift-routes start

source /usr/local/etc/ocp4.config

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} \
    ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-route

oc new-app --image=quay.io/redhattraining/php-hello-dockerfile \
    --name php-helloworld

oc get pods -w

oc logs -f php-helloworld-85484585d6-h4msm

oc describe svc/php-helloworld

oc expose svc/php-helloworld
oc get routes

curl php-helloworld-${RHT_OCP4_DEV_USER}-route.${RHT_OCP4_WILDCARD_DOMAIN}

oc delete route/php-helloworld

oc expose svc/php-helloworld --name=${RHT_OCP4_DEV_USER}-xyz
oc describe route

curl ${RHT_OCP4_DEV_USER}-xyz-${RHT_OCP4_DEV_USER}-route.${RHT_OCP4_WILDCARD_DOMAIN}

lab openshift-routes finish


oc get is -n openshift | less



lab openshift-s2i start
cd DO180-apps
git checkout master

git checkout -b s2i
git push -u origin s2i

source /usr/local/etc/ocp4.config

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-s2i

oc new-app php:7.3 --name=php-helloworld \
    https://github.com/${RHT_OCP4_GITHUB_USER}/DO180-apps#s2i \
    --context-dir php-helloworld

oc get pods
oc logs --all-containers -f php-helloworld-1-build

oc describe deployment/php-helloworld

oc expose service php-helloworld --name ${RHT_OCP4_DEV_USER}-helloworld

oc get route -o jsonpath='{..spec.host}{"\n"}'

curl -s jkvjjx-helloworld-jkvjjx-s2i.apps.eu410.prod.nextcle.com

cd php-helloworld
vim index.php

git add .
git commit -m "Changes index page"
git push origin s2i
oc start-build php-helloworld
oc get pods
oc logs php-helloworld-2-build -f

curl -s ${RHT_OCP4_DEV_USER}-helloworld-${RHT_OCP4_DEV_USER}-s2i.${RHT_OCP4_WILDCARD_DOMAIN}


lab openshift-review start

source /usr/local/etc/ocp4.config

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

oc new-project ${RHT_OCP4_DEV_USER}-ocp

oc new-app php:7.3 --name=temps https://github.com/RedHatTraining/DO180-apps/ --context-dir temps

oc logs -f bc/temps

oc get pods
oc expose svc/temps
oc get routes

echo http://temps-${RHT_OCP4_DEV_USER}-ocp.${RHT_OCP4_WILDCARD_DOMAIN}

lab openshift-review grade

lab openshift-review finish