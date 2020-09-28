FROM dragonwelljdk/build_jdk:8u

ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.121.1}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=5bb075b81a3929ceada4e960049e37df5f15a1e3cfc9dc24d749858e70b48919

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY tini-shim.sh /bin/tini

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
