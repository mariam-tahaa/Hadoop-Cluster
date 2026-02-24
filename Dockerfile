FROM ubuntu:24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    openjdk-11-jdk \
    ssh \
    rsync \
    wget \
    pdsh \
    curl \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Download Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz \
    && tar -xvzf hadoop-3.3.6.tar.gz \
    && mv hadoop-3.3.6 /opt/hadoop \
    && rm hadoop-3.3.6.tar.gz

# Set Hadoop Environment
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

WORKDIR /root