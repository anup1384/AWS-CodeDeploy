#!/bin/bash
sudo service anup-routing stop

# create anup-routing service
cat > /etc/init/anup-routing.conf <<'EOF'

description "anup Routing Server"

  start on runlevel [2345]
  stop on runlevel [!2345]
  respawn
  respawn limit 10 5

  # run as non privileged user 
  # add user with this command:
  ## adduser --system --ingroup www-data --home /opt/apache-tomcat apache-tomcat
  # Ubuntu 12.04: (use 'exec sudo -u apache-tomcat' when using 10.04)
  setuid ubuntu
  setgid ubuntu

  # adapt paths:
  env DATABASE_NAME=anup_routing
  env PG_PASSWORD=AnupJulyFive2018
  env PG_USER=anup
  env DATABASE_SERVER=anup.snsnsjkskjj.us-west-2.rds.amazonaws.com
  env PORT=8080
  env LOG_LEVEL=debug
  env rabbitmq_host=diligent-0----------
  env rabbitmq_username=--------
  env rabbitmq_password=------------
  env google_api_key=------------------
  env environment=prod
  env jsprit_run_size=200
  env jsprit_thread_count=2
  exec java  -Dfile.encoding=UTF-8 -XX:MaxPermSize=256M -Xms512M -Xmx2018M -jar /home/ubuntu/deploy/anup_routing_engine-0.0.1-SNAPSHOT.war --spring.rabbitmq.virtual-host=rejaybnk >> /home/ubuntu/logs/routing.log 2>&1

  # cleanup temp directory after stop
  post-stop script
    #rm -rf $CATALINA_HOME/temp/*
  end script
EOF

# remove old directory
rm -rf /home/ubuntu/deploy

# create directory deploy
mkdir -p /home/ubuntu/deploy 


