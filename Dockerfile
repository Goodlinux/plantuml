FROM maven:ibmjava-alpine
MAINTAINER Ludovic MAILLET <Ludo.Goodlinux@gmail.com>

EXPOSE 8080

ENV MAVEN_CONFIG=/app/.m2  \
    MAVEN_HOME='/usr/share/java/maven3' \
    CRON_HOUR_DELAY=23 \
    CRON_DAY_DELAY=sun \ 
    TZ=Europe/Paris

RUN apk -U add graphviz tzdata git apk-cron 
#maven openjdk11-jre 
RUN mkdir /app  &&  cd /app  \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \ 
    && echo $TZ >  /etc/timezone \
    && git clone https://github.com/plantuml/plantuml-server.git /app/ \
    && git clone https://github.com/plantuml-stdlib/Archimate-PlantUML.git \
    && mvn -U package \     
    && echo "apk -U upgrade " > /usr/local/bin/UpdtPlantuml  \
    && echo "cd /app " >> /usr/local/bin/UpdtPlantuml       \
    && echo "git pull " >> /usr/local/bin/UpdtPlantuml      \
    && echo "mvn -U package " >> /usr/local/bin/UpdtPlantuml    \
    && echo "cd /app/Archimate " >> /usr/local/bin/UpdtPlantuml \
    && echo "git pull " >> /usr/local/bin/UpdtPlantuml  \
    && echo "reboot " >> /usr/local/bin/UpdtPlantuml  \
    && echo "#! /bin/sh" > /usr/local/bin/entrypoint.sh \
    && echo "echo 'parametrage de Cron'" >> /usr/local/bin/entrypoint.sh  \
    && echo "echo '0         \$CRON_HOUR_DELAY     *       *       \$CRON_DAY_DELAY     /usr/local/bin/UpdtPlantuml' > /etc/crontabs/root" >> /usr/local/bin/entrypoint.sh  \
    && echo "echo 'lancement de cron'" >> /usr/local/bin/entrypoint.sh  \
    && echo "crond -b&" >> /usr/local/bin/entrypoint.sh  \
    && echo "echo 'lancement du serveur plantuml'" >> /usr/local/bin/entrypoint.sh  \
    && echo "exec java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war &"  >> /usr/local/bin/entrypoint.sh  \
    && echo "exec /bin/sh" >> /usr/local/bin/entrypoint.sh  \
    && chmod a+x /usr/local/bin/*

WORKDIR /app

#CMD java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war
CMD /usr/local/bin/entrypoint.sh 
