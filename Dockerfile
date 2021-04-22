FROM alpine:latest
MAINTAINER Ludovic MAILLET <Ludo.Goodlinux@gmail.com>

RUN apk -U add graphviz maven tzdata git openjdk11-jre

EXPOSE 8080

ENV TZ=Europe/Paris \
    MAVEN_CONFIG=/app/.m2  \
    MAVEN_HOME='/usr/share/java/maven3' 
    
#JAVA_HOME='/opt/ibm/java/jre'                                                                                                                
#JAVA_VERSION='1.8.0_sr5fp40'
#IBM_JAVA_OPTIONS='-XX:+UseContainerSupport'  
    
    
RUN mkdir /app  &&  cd /app  && git clone https://github.com/plantuml/plantuml-server.git /app/ \
    && git clone https://github.com/plantuml-stdlib/Archimate-PlantUML.git \
    && mvn -U package \
    && cp /usr/share/zoneinfo/$TS /etc/localtime \
    && echo $TZ >  /etc/timezone

WORKDIR /app

#CMD java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war
CMD /bin/sh