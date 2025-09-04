FROM jenkins/jenkins:lts

USER root
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# give jenkins user permission to use docker socket
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins

