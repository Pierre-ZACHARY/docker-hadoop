#!/bin/bash
apt-get update
apt-get install wget
wget --no-check-certificate https://dlcdn.apache.org/pig/pig-0.16.0/pig-0.16.0.tar.gz
wget --no-check-certificate https://dlcdn.apache.org/hbase/2.5.2/hbase-2.5.2-src.tar.gz
wget --no-check-certificate https://dlcdn.apache.org/hive/stable-2/apache-hive-2.3.9-bin.tar.gz
tar xvzf pig-0.16.0.tar.gz
tar xvzf hbase-2.5.2-src.tar.gz
tar xvzf apache-hive-2.3.9-bin.tar.gz
mv ./pig-0.16.0 /root/pig
mv ./hbase-2.5.2 /root/hbase
mv ./apache-hive-2.3.9-bin  /root/hive
rm /root/hive/lib/guava-14.0.1.jar
cp /opt/hadoop-3.2.1/share/hadoop/common/lib/guava-27.0-jre.jar /root/hive/lib/

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "Namenode name directory not found: $namedir"
  exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

echo "remove lost+found from $namedir"
rm -r $namedir/lost+found

if [ "`ls -A $namedir`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
