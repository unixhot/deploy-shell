#!/bin/bash

#Data/Time
CTIME=$(date "+%Y-%m-%d-%H-%M")

#Shell ENV
SHELL_NAME="deploy.sh"
SHELL_DIR="/home/www"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.log"
LOCK_FILE="/tmp/${SHELL_NAME}.lock"

#APP ENV
PNAME="demo"
CODE_DIR="/data/deploy/code"
CONFIG_DIR="/data/deploy/config/"
TMP_DIR="/data/deploy/tmp"
TAR_DIR="/data/deploy/pkg"
PKG_SERVER="192.168.56.11"

shell_log(){
  LOG_INFO=$1
  echo "$CTIME ${SHELL_NAME} : ${LOG_INFO}" >> ${SHELL_LOG}
}

shell_lock(){
  touch ${LOCK_FILE}
}

shell_unlock(){
  rm -f ${LOCK_FILE}
}

usage(){
  echo "Usage: $0 [env deploy version] | rollback-list | rollback | fastrollback"
}

get_pkg(){
  echo "get pkg"
  shell_log "Get PKG" 
  scp www@${PKG_SERVER}:/data/pkg/${PNAME}/${PNAME}.tar.gz ${CODE_DIR}/${PNAME}/
}

config_pkg(){
  echo "config pkg"
  shell_log "Config PKG"
  mkdir ${TMP_DIR}/${PNAME}/${PNAME}
  cd ${CODE_DIR}/${PNAME} && tar zxf ${PNAME}.tar.gz -C ${TMP_DIR}/${PNAME}/${PNAME}
  /bin/cp ${CONFIG_DIR}/${PNAME}/demo-config/$DEPLOY_ENV/* ${TMP_DIR}/${PNAME}/${PNAME}
  /bin/cp -a ${TMP_DIR}/${PNAME}/${PNAME} ${TMP_DIR}/${PNAME}/${PNAME}-${CTIME} 
  cd ${TMP_DIR}/${PNAME} && tar czf ${TAR_DIR}/${PNAME}/${PNAME}-${CTIME}.tar.gz ${PNAME}-${CTIME}
  cd ${TMP_DIR}/${PNAME} && rm -rf *
}

scp_pkg(){
   echo "scp pkg"
   shell_log "SCP pkg"
   scp ${TAR_DIR}/${PNAME}/${PNAME}-${CTIME}.tar.gz www@192.168.56.12:/app-data
}

deploy_pkg(){
  echo "deploy pkg"
  shell_log "Deploy PKG"
  ssh www@192.168.56.12 "cd /app-data/ && tar zxf ${PNAME}-${CTIME}.tar.gz && rm -f /app-root/webroot && ln -s /app-data/${PNAME}-${CTIME} /app-root/webroot"
}

test_pkg(){
  echo "Test"
  shell_log "Test"
  STATUS=$(curl -s --head http://www.baiduasdfasdfasdf.com | grep '200' | wc -l)
  if [ $STATUS = 1 ];then
      echo "OK"
  else
      exit;
  fi
}

fast_rollback(){
  echo "fast rollback"
}

rollback(){
  echo "rollback"
  shell_log "rollback"
  ssh www@192.168.56.12 "rm -f /app-root/webroot && ln -s $DEPLOY_VER /app-root/webroot"
}

rollback_list(){
  echo "rollback list"
  ssh www@192.168.56.12 "ls -l /app-data/*.tar.gz"
}

main(){
  DEPLOY_ENV=$1
  DEPLOY_TYPE=$2
  DEPLOY_VER=$3
  if [ -f "$LOCK_FILE" ];then
     shell_log "${SHELL_NAME} is running"
     echo "${SHELL_NAME} is running" && exit
  fi
  shell_lock;
  case $DEPLOY_TYPE in
    deploy)
       get_pkg;
       config_pkg;
       scp_pkg;
       deploy_pkg;
       test_pkg;
       ;;
    rollback)
       rollback
       ;;
    fast-rollback)
       fast_rollback;
       ;;
    rollback-list)
       rollback_list;
       ;;
     *)
       usage;
     esac
     shell_unlock;
}

main $1 $2 $3
