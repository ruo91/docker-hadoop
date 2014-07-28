# Apache hadoop 2.4.x - Pseudo-Distributed Mode

**- Container run**

    root@ruo91:~# docker run -d -P --name="Hadoop" -h "hadoop" ruo91/hadoop:2.4.1

**- SSH login**

root password : hadoop

    root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' Hadoop`

**- Hadoop run**

    root@hadoop:~# start-all.sh
    root@hadoop:~# jps
    624 NodeManager
    209 DataNode
    659 Jps
    132 NameNode
    540 ResourceManager
    334 SecondaryNameNode

**- Testing**

    root@hadoop:~# for((i=0; i<10; i++)) do echo ${i}; done > test.log
    root@hadoop:~# hdfs dfs -copyFromLocal test.log /
    root@hadoop:~# hdfs dfs -ls /
    Found 1 items
    -rw-r--r--   3 root supergroup         20 2014-05-03 04:50 /test.log
    root@hadoop:~# exit
    root@ruo91:~# docker port Hadoop 50070
    0.0.0.0:49181

**- Web**

Overview
![enter image description here][1]

Data Node
![enter image description here][2]

Utilities - Browse the file system
![enter image description here][3]

Thanks. :-)


  [1]: http://cdn.yongbok.net/ruo91/img/hadoop/2.4.0/apache_hadoop_2.4.0_namenode.png
  [2]: http://cdn.yongbok.net/ruo91/img/hadoop/2.4.0/apache_hadoop_2.4.0_datanode.png
  [3]: http://cdn.yongbok.net/ruo91/img/hadoop/2.4.0/apache_hadoop_2.4.0_explorer.png
