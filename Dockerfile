# Docker-in-Docker Jenkins Slave
#
# See: https://github.com/tehranian/dind-jenkins-slave
# See: https://dantehranian.wordpress.com/2014/10/25/building-docker-images-within-docker-containers-via-jenkins/
#
# Following the best practices outlined in:
#   http://jonathan.bergknoff.com/journal/building-good-docker-images

FROM evarga/jenkins-slave

ENV DEBIAN_FRONTEND noninteractive

# Adapted from: https://registry.hub.docker.com/u/jpetazzo/dind/dockerfile/
# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables && \
    rm -rf /var/lib/apt/lists/*

RUN echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

ENV DOCKER_VERSION 1.7.1

# Install Docker from Docker Inc. repositories.
RUN apt-get update && apt-get install -y lxc-docker=$DOCKER_VERSION && rm -rf /var/lib/apt/lists/*

ADD wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker
VOLUME /var/lib/docker


# Make sure that the "jenkins" user from evarga's image is part of the "docker"
# group. Needed to access the docker daemon's unix socket.
RUN usermod -a -G docker jenkins


# place the jenkins slave startup script into the container
ADD jenkins-slave-startup.sh /
CMD ["/jenkins-slave-startup.sh"]
