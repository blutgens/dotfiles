CLASSPATH=.:/opt:/opt/CLpgms:/opt/CLpayroll
CLASSPATH=$CLASSPATH:/opt/cljava/cllbls  # Added by DanC 20 Feb 2004

for jarfile in `ls -r /opt/jar/*.zip`
do
    CLASSPATH=$CLASSPATH:$jarfile
done
for jarfile in `ls -r /opt/jar/*.jar`
do
    CLASSPATH=$CLASSPATH:$jarfile
done
for jarfile in `ls -r /opt/jakarta-tomcat-4.0.2/common/lib/*.jar`
do
    CLASSPATH=$CLASSPATH:$jarfile
done

export CLASSPATH
export JAVA_HOME="/opt/j2sdk1.4.2_15"
