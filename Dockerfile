FROM alpine:latest
MAINTAINER Ludovic MAILLET <Ludo.Goodlinux@gmail.com>

EXPOSE 8080

ENV CRON_HOUR_START=23 \
    CRON_DAY_START=sun \
	SERVER_NAME="My serveur"   \
    TZ=Europe/Paris

RUN apk -U add graphviz tzdata git apk-cron maven font-noto
#maven openjdk11-jre 
RUN mkdir /app  \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \ 
    && echo $TZ >  /etc/timezone 
RUN git clone https://github.com/plantuml/plantuml-server.git /app/ 
RUN git clone https://github.com/plantuml-stdlib/Archimate-PlantUML.git /app/Archimate-PlantUML/
RUN cd /app &&  mvn -U package 
RUN echo "apk -U upgrade "						> /usr/local/bin/UpdtPlantuml  \
    && echo "cd /app/Archimate-PlantUML "				>> /usr/local/bin/UpdtPlantuml \
    && echo "git pull " 						>> /usr/local/bin/UpdtPlantuml  \
    && echo "cd /app "							>> /usr/local/bin/UpdtPlantuml       \
    && echo "git pull " 						>> /usr/local/bin/UpdtPlantuml      \
    && echo "mvn -U package "						>> /usr/local/bin/UpdtPlantuml    \
    && echo "reboot "							>> /usr/local/bin/UpdtPlantuml  	\
    && echo "#! /bin/sh"							> /usr/local/bin/entrypoint.sh \
    && echo "echo 'parametrage de Cron'" 					>> /usr/local/bin/entrypoint.sh  \
    && echo "echo '0         '\$CRON_HOUR_START'     *       *       '\$CRON_DAY_START'     /usr/local/bin/UpdtPlantuml' > /etc/crontabs/root" >> /usr/local/bin/entrypoint.sh  \
    && echo "echo 'lancement de cron'" 						>> /usr/local/bin/entrypoint.sh  \
    && echo "echo '<p>Server  $SERVER_NAME : <%= net.sourceforge.plantuml.version.Version.fullDescription() %></p>' > /app/target/plantuml/resource/footer.jspf"	>> /usr/local/bin/entrypoint.sh  \
    && echo "crond -b&" 							>> /usr/local/bin/entrypoint.sh  \
    && echo "echo 'lancement du serveur plantuml'"				>> /usr/local/bin/entrypoint.sh  \
    && echo "exec java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war &" >> /usr/local/bin/entrypoint.sh  \
    && echo "exec /bin/sh"							>> /usr/local/bin/entrypoint.sh  \
    && chmod a+x /usr/local/bin/*

WORKDIR /app

#CMD java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war
CMD /usr/local/bin/entrypoint.sh
