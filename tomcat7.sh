export JAVA_HOME=/usr/lib/jvm/java-7-oracle/
export JAVA_OPTS="-Dfile.encoding=UTF-8 \
-Dcatalina.logbase=/var/log/tomcatProd \
-Dnet.sf.ehcache.skipUpdateCheck=true \
-XX:+UseConcMarkSweepGC \
-XX:+CMSClassUnloadingEnabled \
-XX:+UseParNewGC \
-XX:MaxPermSize=128m \
-Xms512m -Xmx512m"
export PATH=$JAVA_HOME/bin:$PATH
TOMCAT_HOME=/opt/tomcat7
SHUTDOWN_WAIT=20
export CATALINA_OPTS="-Xmx512m"

export CATALINA_BASE=/opt/tomcat7

tomcat_pid() {
  echo `ps aux | grep org.apache.catalina.startup.Bootstrap | grep $CATALINA_BASE | grep -v grep | awk '{ print $2 }'`
}
start() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
echo "Tomcat is already running (pid: $pid)"
  else
    # Start tomcat
    echo "Starting tomcat"
    #ulimit -n 100000
    umask 007
    $TOMCAT_HOME/bin/startup.sh
  fi
return 0
}

stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
echo "Stoping Tomcat"
    if [ "$USER" == "$TOMCAT_USER" ]
    then
         $TOMCAT_HOME/bin/shutdown.sh
    else
        /bin/su -p -s /bin/sh $TOMCAT_USER $TOMCAT_HOME/bin/shutdown.sh
    fi

    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
echo -n -e "\nwaiting for processes to exit";
      sleep 1
      let count=$count+1;
    done

if [ $count -gt $kwait ]; then
echo -n -e "\nkilling processes which didn't stop after $SHUTDOWN_WAIT seconds"
      kill -9 $pid
    fi
else
echo "Tomcat is not running"
  fi
return 0
}

case $1 in
start)
  start
;;
stop)
  stop
;;
restart)
  stop
  start
;;
status)
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
echo "Tomcat is running with pid: $pid"
  else
echo "Tomcat is not running"
  fi
;;
esac
exit 0
