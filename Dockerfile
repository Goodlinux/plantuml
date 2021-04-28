FROM maven:ibmjava-alpine
MAINTAINER Ludovic MAILLET <Ludo.Goodlinux@gmail.com>

EXPOSE 8080

ENV MAVEN_CONFIG=/app/.m2  \
    MAVEN_HOME='/usr/share/java/maven3' \
    TZ=Europe/Paris

RUN apk -U add graphviz tzdata git 
#maven openjdk11-jre 
RUN mkdir /app  &&  cd /app  \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \ 
    && echo $TZ >  /etc/timezone \
    && git clone https://github.com/plantuml/plantuml-server.git /app/ \
    && git clone https://github.com/plantuml-stdlib/Archimate-PlantUML.git \
    && mvn -U package 

WORKDIR /app

CMD java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war
#CMD /bin/sh
