FROM quay.io/vektorcloud/python:3

RUN apk add --no-cache bash build-base ca-certificates curl coreutils docker \
  git openssh libressl libressl-dev libffi-dev make tree jq

# from https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBE_VERSION v1.16.1
# from https://api.github.com/repos/kubernetes/kops/releases/latest
ENV KOPS_VERSION 1.10.0
ENV HELM_VERSION v2.10.0
ENV TERRAFORM_VERSION 0.12.10

WORKDIR /build

# install kubectl
RUN wget -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl && \
   chmod +x /usr/local/bin/kubectl

# install kops
RUN wget -O /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 && \
   chmod +x /usr/local/bin/kops

# install helm
RUN wget -O helm.tgz https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xvf helm.tgz && \
    mv -v linux-amd64/helm /usr/local/bin/ && \
    rm -rf /build/*

# install terraform
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    rm -rf /build/*

ENV GOOGLE_APPLICATION_CREDENTIALS /account.json
ENV CLOUDSDK_INSTALL_DIR /opt
ENV CLOUDSDK_CORE_PROJECT lsms-183111
ENV PATH=$PATH:/opt/google-cloud-sdk/bin

RUN wget -O /tmp/install.sh https://sdk.cloud.google.com && \
    bash /tmp/install.sh && \
    pip install -U crcmod

COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]
