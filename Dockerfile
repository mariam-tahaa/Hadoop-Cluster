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

# Download ZooKeeper
RUN cd /opt && \
    wget https://downloads.apache.org/zookeeper/zookeeper-3.9.4/apache-zookeeper-3.9.4-bin.tar.gz && \
    tar -xzvf apache-zookeeper-3.9.4-bin.tar.gz && \
    mv apache-zookeeper-3.9.4-bin /opt/zookeeper && \
    rm apache-zookeeper-3.9.4-bin.tar.gz

# Create Zookeeper data directory
RUN mkdir -p /opt/data/zookeeper && \
    chown -R root:root /opt/data/zookeeper && \
    chmod -R 755 /opt/data/zookeeper

# Create zoo.cfg automatically
RUN cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg && \
    echo "tickTime=2000" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "dataDir=/opt/data/zookeeper" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "clientPort=2181" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "initLimit=5" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "syncLimit=2" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "server.1=node01:2888:3888" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "server.2=node02:2888:3888" >> /opt/zookeeper/conf/zoo.cfg && \
    echo "server.3=node03:2888:3888" >> /opt/zookeeper/conf/zoo.cfg

# Set Hadoop Environment
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

WORKDIR /root