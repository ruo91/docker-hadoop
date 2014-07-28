#
# Dockerfile - Apache hadoop
#
FROM     ubuntu:14.04
MAINTAINER Yongbok Kim <ruo91@yongbok.net>

# Last Package Update & Install
RUN apt-get update && apt-get install -y curl supervisor openssh-server net-tools iputils-ping nano

# JDK
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin
RUN curl -LO "http://download.oracle.com/otn-pub/java/jdk/8u11-b12/jdk-8u11-linux-x64.tar.gz" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
 && tar xzf jdk-8u11-linux-x64.tar.gz && mv jdk1.8.0_11 /usr/local/jdk && rm -f jdk-8u11-linux-x64.tar.gz \
 && echo '' >> /etc/profile \
 && echo '# JDK' >> /etc/profile \
 && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
 && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile \
 && echo '' >> /etc/profile

# Apache Hadoop
ENV SRC_DIR /opt
ENV HADOOP_VERSION hadoop-2.4.1
RUN cd $SRC_DIR && curl -LO "http://www.us.apache.org/dist/hadoop/common/$HADOOP_VERSION/$HADOOP_VERSION.tar.gz" \
 && tar xzf $HADOOP_VERSION.tar.gz ; rm -f $HADOOP_VERSION.tar.gz

# Hadoop ENV
ENV HADOOP_PREFIX $SRC_DIR/$HADOOP_VERSION
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin
ENV HADOOP_MAPRED_HOME $HADOOP_PREFIX
ENV HADOOP_COMMON_HOME $HADOOP_PREFIX
ENV HADOOP_HDFS_HOME $HADOOP_PREFIX
ENV YARN_HOME $HADOOP_PREFIX
RUN echo '# Hadoop' >> /etc/profile
RUN echo "export HADOOP_PREFIX=$SRC_DIR/$HADOOP_VERSION" >> /etc/profile
RUN echo 'export PATH=$PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin' >> /etc/profile
RUN echo 'export HADOOP_MAPRED_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export HADOOP_COMMON_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export HADOOP_HDFS_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export YARN_HOME=$HADOOP_PREFIX' >> /etc/profile

# Add in the etc/hadoop directory
ADD conf/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
ADD conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/local/jdk:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# Native
# https://gist.github.com/ruo91/7154697#comment-936487
RUN echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_PREFIX/lib/native' >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_OPTS=-Djava.library.path=$HADOOP_PREFIX/lib' >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_PREFIX/lib/native' >> $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
RUN echo 'export HADOOP_OPTS=-Djava.library.path=$HADOOP_PREFIX/lib' >> $HADOOP_PREFIX/etc/hadoop/yarn-env.sh

# SSH keygen
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" \
 && cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && chmod 644 /root/.ssh/authorized_keys

# Name node foramt
RUN hdfs namenode -format

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/without-password/yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo 'SSHD: ALL' >> /etc/hosts.allow

# Root password
RUN echo 'root:hadoop' |chpasswd

# Port
EXPOSE 22 8030 8031 8032 8033 8040 8042 8088 9000 50010 50020 50070 50075 50090

# Daemon
CMD ["/usr/bin/supervisord"]
