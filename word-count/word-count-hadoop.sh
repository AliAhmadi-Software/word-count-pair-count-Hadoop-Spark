###Run Default Hadoop Word Count MapReduce on Ubuntu

#0. Start HDFS & Yarn
start-dfs.sh

start-yarn.sh

#1. Create localfile for counting
touch localfile.txt

nano localfile.txt

#add these line at the end of file
Hello Hadoop
Hello MapReduce
Hello Big Data
Hello Graph
#Save & Quit

#2. Upload on HDFS
hadoop fs -mkdir /

hadoop fs -put localfile.txt /input

#3. Find & Config for run MapReduce

#See You have Permission to execute or not
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar

#if You don't have Permission
#See if you have x for owner...
ls -l $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar

chmod +x $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar

#4. Execute Word Count MapReduce
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /input /output

#5. See the Result
hadoop fs -cat /output/part-r-00000
#if you don't see it you may have Error, So follow these steps

#6. Config mapred-site.xml
nano $HADOOP_HOME/etc/hadoop/mapred-site.xml

#add these line at the between <configure> ... </configure>
<property>
  <name>yarn.app.mapreduce.am.env</name>
  <value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
</property>
<property>
  <name>mapreduce.map.env</name>
  <value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
</property>
<property>
  <name>mapreduce.reduce.env</name>
  <value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
</property>
#Save & Quit

#7. Config bashrc
nano ~/.bashrc

#add these line at the end of file
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
#Save & Quit

source ~/.bashrc

#8. Restart HDFS & Yarn
stop-dfs.sh

stop-yarn.sh

start-dfs.sh

start-yarn.sh

#9. Run Again
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /input /output

hadoop fs -cat /output/part-r-00000

#10. Now you have see these in output:
Big	1
Data	1
Graph	1
Hadoop	1
Hello	4
MapReduce	1
