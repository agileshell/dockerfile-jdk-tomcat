## dockerfile-jdk-tomcat

A Dockerfile that installs the latest jdk7, tomcat7.

### Prerequisite

Get and [install Docker](http://www.docker.io/gettingstarted/)!

You should be able to run the docker command line without sudo. Otherwise you will have to make some adjustments.

### Usage

Bulid a new image:
```
$ git clone https://github.com/agileshell/dockerfile-jdk-tomcat.git
$ cd dockerfile-jdk-tomcat
$ sudo docker build -t dockerfile-jdk-tomcat .
```

We can now fire a new container based on this image:
```
docker run -d -p 8090:8080 dockerfile-jdk-tomcat
```
After few seconds, open `http://<host>:8090` to see the welcome page.
