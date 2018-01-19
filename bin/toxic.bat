@echo off

set classpath=""
set classpath="%classpath%:%TOXIC_HOME%/conf"
set classpath="$classpath%:%TOXIC_HOME%/lib/*"
set classpath="%classpath%:%TOXIC_HOME%/gen/class"

java -Djavax.net.ssl.trustStore=%TOXIC_HOME%/conf/toxic.jks -cp %classpath% toxic.Main %1% %2% %3% %4% %5% %6% %7% %8% %9% %10% 
