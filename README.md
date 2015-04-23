# Apache Hadoop 2.x - Pseudo-Distributed Mode
**- Container run**

    root@ruo91:~# docker run -d --name="hadoop" -h "hadoop" \
    -p 8042:8042 -p 8088:8088 -p 50070:50070 -p 50075:50075 -p 50090:50090 ruo91/hadoop:2.7.x
or

**- Build**

    root@ruo91:~# git clone https://github.com/ruo91/docker-hadoop.git /opt/docker-hadoop
    root@ruo91:~# cd /opt/docker-hadoop
    root@ruo91:~# git checkout -b 2.7.x origin/2.7.x
    root@ruo91:~# docker build --rm -t hadoop:2.7.x /opt/docker-hadoop

**- Container run**

    root@ruo91:~# docker run -d --name="hadoop" -h "hadoop" \
    -p 8042:8042 -p 8088:8088 -p 50070:50070 -p 50075:50075 -p 50090:50090 hadoop:2.7.x

**- SSH login**

root password : hadoop

    root@ruo91:~# ssh `docker inspect -f '{{ .NetworkSettings.IPAddress }}' hadoop`

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
or

    root@hadoop:~# hadoop jar \
    $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples*.jar pi 3 3
    Number of Maps  = 3
    Samples per Map = 3
    Wrote input for Map #0
    Wrote input for Map #1
    Wrote input for Map #2
    Starting Job
    14/08/29 09:43:26 INFO client.RMProxy: Connecting to ResourceManager at /0.0.0.0:8032
    14/08/29 09:43:26 INFO input.FileInputFormat: Total input paths to process : 3
    14/08/29 09:43:26 INFO mapreduce.JobSubmitter: number of splits:3
    14/08/29 09:43:27 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1409304988887_0003
    14/08/29 09:43:27 INFO impl.YarnClientImpl: Submitted application application_1409304988887_0003
    14/08/29 09:43:27 INFO mapreduce.Job: The url to track the job: http://hadoop:8088/proxy/application_1409304988887_0003/
    14/08/29 09:43:27 INFO mapreduce.Job: Running job: job_1409304988887_0003
    14/08/29 09:43:33 INFO mapreduce.Job: Job job_1409304988887_0003 running in uber mode : false
    14/08/29 09:43:33 INFO mapreduce.Job:  map 0% reduce 0%
    14/08/29 09:43:41 INFO mapreduce.Job:  map 67% reduce 0%
    14/08/29 09:43:42 INFO mapreduce.Job:  map 100% reduce 0%
    14/08/29 09:43:47 INFO mapreduce.Job:  map 100% reduce 100%
    14/08/29 09:43:47 INFO mapreduce.Job: Job job_1409304988887_0003 completed successfully
    14/08/29 09:43:47 INFO mapreduce.Job: Counters: 49
            File System Counters
                FILE: Number of bytes read=72
                FILE: Number of bytes written=389309
                FILE: Number of read operations=0
                FILE: Number of large read operations=0
                FILE: Number of write operations=0
                HDFS: Number of bytes read=792
                HDFS: Number of bytes written=215
                HDFS: Number of read operations=15
                HDFS: Number of large read operations=0
                HDFS: Number of write operations=3
        Job Counters
                Launched map tasks=3
                Launched reduce tasks=1
                Data-local map tasks=3
                Total time spent by all maps in occupied slots (ms)=17686
                Total time spent by all reduces in occupied slots (ms)=3917
                Total time spent by all map tasks (ms)=17686
                Total time spent by all reduce tasks (ms)=3917
                Total vcore-seconds taken by all map tasks=17686
                Total vcore-seconds taken by all reduce tasks=3917
                Total megabyte-seconds taken by all map tasks=18110464
                Total megabyte-seconds taken by all reduce tasks=4011008
        Map-Reduce Framework
                Map input records=3
                Map output records=6
                Map output bytes=54
                Map output materialized bytes=84
                Input split bytes=438
                Combine input records=0
                Combine output records=0
                Reduce input groups=2
                Reduce shuffle bytes=84
                Reduce input records=6
                Reduce output records=0
                Spilled Records=12
                Shuffled Maps =3
                Failed Shuffles=0
                Merged Map outputs=3
                GC time elapsed (ms)=426
                CPU time spent (ms)=1450
                Physical memory (bytes) snapshot=807591936
                Virtual memory (bytes) snapshot=7788961792
                Total committed heap usage (bytes)=607125504
        Shuffle Errors
                BAD_ID=0
                CONNECTION=0
                IO_ERROR=0
                WRONG_LENGTH=0
                WRONG_MAP=0
                WRONG_REDUCE=0
        File Input Format Counters
                Bytes Read=354
        File Output Format Counters
                Bytes Written=97
    Job Finished in 21.529 seconds
    Estimated value of Pi is 3.55555555555555555556

**- Web UI**

Namenode Information
![Namenode Information][1]

Datanode Information
![Datanode Information][2]

Secondarynode Information
![Secondarynode Information][3]

Startup progress Information
![Startup progress Information][4]

Utilities - Browse the file system
![Browsing HDFS][5]

Nodemanager Information
![Nodemanager Information][6]

Resource manager Information
![Resource Manager Information][7]


Thanks. :-)


  [1]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_namenode.png
  [2]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_datanode.png
  [3]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_secondarynode.png
  [4]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_startup_progress.png
  [5]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_browsing_hdfs.png
  [6]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_nodemanager.png
  [7]: http://cdn.yongbok.net/ruo91/img/hadoop/2.x/apache_hadoop_resourcemanager.png
