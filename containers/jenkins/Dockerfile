FROM jenkins:1.625.3
MAINTAINER John Felten <john.felten@gmail.com>
VOLUME /var/jenkins_home
VOLUME /etc/jenkins_jobs

ENV GOLANG_DEB_VERSION=2:1.6.1+1~bpo8+1 \
    TERRAFORM_VERSION=0.6.16 \
    TERRAFORM_EXECUTE_VERSION=v0.0.2 \
    TERRAFORM_COREOSBOX_VERSION=v0.0.1 \
    GOOGLE_CLOUD_SDK_VERSION=117.0.0 \
    KUBERNETES_VERSION=v1.3.2

# Configure SSH
USER root
#COPY keys /root/.ssh/
#RUN chmod 400 /root/.ssh/id_rsa

# Preload host keys for github.com
#RUN ssh-keyscan -H github.com >> /root/.ssh/known_hosts

# Install Jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

# Install apt managed packages (python, ruby, golang, etc.)
ENV GOROOT=/usr/lib/go
RUN apt-get update --fix-missing --no-install-recommends\
    && apt-get install -y --force-yes \
      curl \
      unzip \
      jq \
      ruby \
      ruby-dev \
      build-essential \
      libssl-dev \
      libffi-dev \
      git \
      python \
      python-dev \
      python-pip \
      vim \
      golang-doc=${GOLANG_DEB_VERSION} \
      golang-go=${GOLANG_DEB_VERSION} \
      golang-src=${GOLANG_DEB_VERSION} \
      rsync \
      dnsutils\
    && rm -rf /var/lib/apt/lists/*

# All python modules should be installed here if possible
COPY requirements.txt /opt/kraken-ci/containers/jenkins/
RUN pip install --upgrade pip \
  && pip install --requirement /opt/kraken-ci/containers/jenkins/requirements.txt\
  && pip install virtualenv \
  && pip install --user jenkins-job-builder

# All ruby gems should be installed here if possible
COPY Gemfile Gemfile.lock /opt/kraken-ci/containers/jenkins/
RUN gem install bundler \
  && bundler install --gemfile=/opt/kraken-ci/containers/jenkins/Gemfile

# Install terraform and custom providers
#RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
#  && wget https://github.com/samsung-cnct/terraform-provider-execute/releases/download/${TERRAFORM_EXECUTE_VERSION}/terraform-provider-execute_linux_amd64.tar.gz \
#  && wget https://github.com/samsung-cnct/terraform-provider-coreosbox/releases/download/${TERRAFORM_COREOSBOX_VERSION}/terraform-provider-coreosbox_linux_amd64.tar.gz \
#  && unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
#  && tar -xvf terraform-provider-coreosbox_linux_amd64.tar.gz \
#  && tar -xvf terraform-provider-execute_linux_amd64.tar.gz \
#  && cp terraform* /usr/local/bin \
#  && rm terraform*

# Install Google Cloud SDK
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
  && tar xzf google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
  && rm google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
  && google-cloud-sdk/install.sh --usage-reporting=false --path-update true --bash-completion true --rc-path ~/.bashrc \
  && rm -rf /google-cloud-sdk

# Install kubectl
RUN wget https://github.com/kubernetes/kubernetes/releases/download/${KUBERNETES_VERSION}/kubernetes.tar.gz \
  && tar -xvf kubernetes.tar.gz \
  && cp kubernetes/platforms/linux/amd64/kubectl /usr/bin \
  && rm -rf /kubernetes \
  && rm kubernetes.tar.gz

# Configure Ansible
COPY ansible.cfg /etc/ansible/ansible.cfg

COPY ./job-builder/ /etc/jenkins_jobs/
RUN mkdir -p /var/jenkins_home/
COPY config/* /var/jenkins_home/
#COPY ./job-builder/jobs/jobs /var/jenkins_home/jobs
#RUN java $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS "$@" & 2>&1 \
#	&& while [ $(curl -s -w "%{http_code}" http://localhost:8080/api/json -o /dev/null) != "200" ]; do sleep 1 && echo -n .; done\
#	&& jenkins-jobs update --recursive --exclude /etc/jenkins_jobs/jobs/excluded-on-jenkins:/etc/jenkins_jobs/jobs/k2-configs /etc/jenkins_jobs
	
