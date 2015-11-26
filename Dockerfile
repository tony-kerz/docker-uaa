FROM java:openjdk-8u66-jre
MAINTAINER healthagen

ENV UAA_CONFIG_PATH /uaa
ENV CATALINA_HOME /tomcat
ENV UAA_VER 2.7.2
ENV TC_VER 8.0.28

ADD run.sh /tmp/
ADD uaa.yml /uaa/uaa.yml
RUN chmod +x /tmp/run.sh

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v$TC_VER/bin/apache-tomcat-$TC_VER.tar.gz
RUN wget -qO- https://archive.apache.org/dist/tomcat/tomcat-8/v$TC_VER/bin/apache-tomcat-$TC_VER.tar.gz.md5 | md5sum -c -

RUN tar zxf apache-tomcat-$TC_VER.tar.gz
RUN rm apache-tomcat-$TC_VER.tar.gz

RUN mkdir /tomcat
RUN mv apache-tomcat-8.0.28/* /tomcat
RUN rm -rf /tomcat/webapps/*


ADD cloudfoundry-identity-uaa-$UAA_VER.war /tomcat/webapps/
RUN mv /tomcat/webapps/cloudfoundry-identity-uaa-$UAA_VER.war /tomcat/webapps/ROOT.war

#VOLUME ["/uaa"]

# install docker
# http://askubuntu.com/a/211531
RUN apt-get -y update
RUN apt-get -y install apt-transport-https
#
RUN echo deb http://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
#
RUN apt-get -y update
RUN apt-get -y install lxc-docker-1.7.1

EXPOSE 8080

ENTRYPOINT ["/tmp/run.sh"]
