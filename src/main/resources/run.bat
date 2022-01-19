chcp 65001
java -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8 -Dlogback.configurationFile=logback.xml -jar wowchat-mqtt.jar wowchat.conf
pause
