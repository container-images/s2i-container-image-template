FROM registry.fedoraproject.org/fedora:26

# Additional packages
#  * findutils - for helper scripts inside the container

LABEL MAINTAINER ...

ENV NAME=mycontainer VERSION=0 RELEASE=1 ARCH=x86_64

ENV HOME=/opt/app-root

LABEL summary="Postfix is a Mail Transport Agent (MTA)." \
      com.redhat.component="$NAME" \
      version="$VERSION" \
      release="$RELEASE.$DISTTAG" \
      architecture="$ARCH" \
      usage="docker run -p 9000:9000 f26/mycontainer" \
      help="Runs mycontainer, which listens on port 9000 and tells you how awesome it is. No dependencies." \
      description="Postfix is mail transfer agent that routes and delivers mail." \
      vendor="Fedora Project" \
      org.fedoraproject.component="postfix" \
      authoritative-source-url="registry.fedoraproject.org" \
      io.k8s.description="Postfix is mail transfer agent that routes and delivers mail." \
      io.k8s.display-name="Postfix 3.1" \
      io.openshift.expose-services="10025:postfix" \
      io.openshift.tags="postfix,mail,mta" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"

RUN dnf install --nodocs -y findutils && \
    dnf clean all

# S2I scripts
COPY ./s2i/bin/ /usr/local/s2i

COPY root /

# add container files
COPY files /files

RUN touch /etc/service.conf && \
    mkdir -p ${HOME}/src && \
    useradd -u 1001 -r -g 0 -s /sbin/nologin service && \
    /usr/libexec/fix-permissions /etc/service.conf ${HOME}/src/ && \
    usermod -a -G root service

WORKDIR ${HOME}/src

CMD ["/usr/bin/run-service"]

USER 1001
