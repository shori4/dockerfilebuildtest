# OpenShift Jenkins Slave Pod.

# The v3.7 digest...
FROM openshift/jenkins-slave-base-centos7@sha256:3059d49e6666c0bc6198d20e956a5b03589bab6e06e26906c19c64ed55922754
MAINTAINER Sato Hori 

USER 0

# Install gcc
RUN yum -y group install "Development Tools"

# Install Python
RUN yum -y install yum-utils
RUN yum -y groupinstall development
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install \
    python36u \
    python36u-pip \
    python36u-devel

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2

RUN alternatives --install /usr/bin/pip pip /usr/bin/pip3.6 10

RUN pip install --upgrade pip

# Adjust path for ''--user' use of pip
# where stuff gets installed in ${HOME}/.local/bin
ENV PATH ${PATH}:/home/jenkins/.local/bin

# To fix the error: -
#       UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3
#                in position 3516: ordinal not in range(128)
# Seen when trying to install pyroma v2.3.
# We ned to set `LC_ALL` and allow utc-8.
ENV LC_ALL=en_US.UTF-8

RUN chown -R 1001:0 /usr/lib/python2.7/site-packages 
RUN chown -R 1001:0 /usr/lib/python3.6/site-packages

WORKDIR ${HOME}

