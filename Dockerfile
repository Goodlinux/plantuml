FROM maven:ibmjava-alpine
MAINTAINER Ludovic MAILLET <Ludo.Goodlinux@gmail.com>

EXPOSE 8080

ENV TZ=Europe/Paris \
    MAVEN_CONFIG=/app/.m2  \
    MAVEN_HOME='/usr/share/java/maven3' 
    
#JAVA_HOME='/opt/ibm/java/jre'                                                                                                                
#JAVA_VERSION='1.8.0_sr5fp40'
#IBM_JAVA_OPTIONS='-XX:+UseContainerSupport'  
    
    
RUN apk -U add graphviz tzdata git 
#maven openjdk11-jre 
RUN mkdir /app  &&  cd /app  \
#    && cp /usr/share/zoneinfo/$TS /etc/localtime \
#    && echo $TZ >  /etc/timezone  \
    && git clone https://github.com/plantuml/plantuml-server.git /app/ \
    && git clone https://github.com/plantuml-stdlib/Archimate-PlantUML.git \
    && mvn -U package 


WORKDIR /app

#CMD java -Djetty.contextpath=/ -jar target/dependency/jetty-runner.jar target/plantuml.war
CMD /bin/sh
