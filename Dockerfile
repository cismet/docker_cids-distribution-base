ARG IMAGE_VERSION=8.0-debian

FROM debian:buster

# STUFF

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get -y --no-install-recommends install ca-certificates curl gcc jq less libc6-dev libssl-dev locales locales-all make openssl postgresql-client procps unzip vim wget zip 


# JAVA

ENV JAVA_VERSION 8
ENV JAVA_UPDATE 333
ENV JAVA_BUILD 02
ENV JAVA_PATH 2dee051a5d0647d5be72a7c0abff270e
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-oracle
ENV JAVA_JRE ${JAVA_HOME}/jre

RUN mkdir -p /usr/lib/jvm \
    && wget -c -qO- --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} "${JAVA_HOME}" \
    && update-alternatives --install "/usr/bin/java" "java" "${JAVA_JRE}/bin/java" 1 \ 
    && update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 \
    && update-alternatives --set java "${JAVA_JRE}/bin/java" \
    && update-alternatives --set javac "${JAVA_HOME}/bin/javac"

ENV PATH="${JAVA_HOME}/bin:${PATH}"

# MAVEN

ENV MAVEN_MIRROR http://www-eu.apache.org/dist/maven/maven-3/
ENV MAVEN_OPTS -XX:-OmitStackTraceInFastThrow -server -Xms512m -Xmx1024m
ENV MAVEN_VERSION 3.9.1
ENV MAVEN_HOME /usr/share/maven

RUN mkdir -p ${MAVEN_HOME} \
    && curl -fsSL ${MAVEN_MIRROR}/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar -xzC ${MAVEN_HOME} --strip-components=1 \
    && ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn


# NGINX, DUMB-INIT, GIT
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get -y --no-install-recommends install dumb-init git nginx openssh-client sysv-rc-conf


# GITLAB-RUNNER

RUN curl -Ls --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64" \
 && chmod +x /usr/local/bin/gitlab-runner \
 && mkdir /gitlab-runner \
 && gitlab-runner install --user=root --working-directory=/gitlab-runner
 

# CLEANUP

RUN apt-get remove --purge --auto-remove -y gcc libc6-dev libssl-dev make sysv-rc-conf


# ===

LABEL de.cismet.cids.java.maven.name="cids-distribution-base runtime image" \
      de.cismet.cids.java.maven.version="cids-distribution-base ${IMAGE_VERSION} jdk-1.${JAVA_VERSION}u${JAVA_UPDATE}" \
      de.cismet.cids.java.maven.tag.docker="cids-distribution-base ${IMAGE_VERSION} jdk-1.${JAVA_VERSION}u${JAVA_UPDATE}" \
      de.cismet.cids.java.maven.tag.git="cids-distribution-base:${IMAGE_VERSION} jdk-1.${JAVA_VERSION}u${JAVA_UPDATE}" \
      de.cismet.cids.java.maven.description="Java and Maven Runtime Image" 

LABEL maintainer="Jean-Michel Ruiz <jean.ruiz@cismet.de>"