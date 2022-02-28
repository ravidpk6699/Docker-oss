FROM tomcat:9.0
COPY ./target/WebApp.war /opt/tomcat/webapps
