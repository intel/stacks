# Data Services Reference Stack(DSRS) – Spark  

DSRS Spark is packaged as a Docker container based on CentOS 8 and a set of scripts to build components including: 

- [Apache Spark](https://spark.apache.org/) 

- [Apache Hadoop](https://hadoop.apache.org/)  

- [Intel® MKL](https://software.intel.com/content/www/us/en/develop/tools/math-kernel-library.html) or [OpenBLAS](https://www.openblas.net/) depending on the image you are using.

## Source code

The latest source code and documentation related to build and deploy the image can be found here:

- [https://github.com/intel/stacks](https://github.com/intel/stacks)


## DSRS Spark Stack

DSRS Spark Stack releases two Docker images that ships Spark 3.0.0, OpenJDK11, Hadoop 3.2.0 and BLAS libraries (either MKL or OpenBLAS):

1. CentOS based image with Intel MKL library, hereafter MKL image
2. CentOS based image with OpenBLAS library, hereafter OpenBLAS image

The docker images provides development tools and frameworks including Spark and Hadoop optimized for Intel plattforms. You can use this environment to store and process large amounts of data, or try new ideas.

## Pull DSRS Spark images

If you want to fetch the MKL image run the command:

```bash
docker pull sysstacks/dsrs-spark-centos:latest
```

For the OpenBLAS image run the command:

```bash
docker pull sysstacks/dsrs-spark-centos:latest-oss
```

The difference in the name resides in the tag postfix. OpenBLAS image tag ends with `-oss` meaning "open source software", this type of naming convention is used to indicate that the image has no Intel specific software included.

For the following steps of the documentation, we will use the MKL image as reference, nevertheless it is the same for both flavor of images.

## Build DSRS Spark image

To build an MKL image by yourself, install the docker dependencies and run the following command:

```bash
docker build --force-rm --no-cache -f Dockerfile -t ${DOCKER_IMAGE} .
```

To build an OpenBLAS image, the build command is the following:

```bash
docker build --force-rm --no-cache -f oss.Dockerfile -t ${DOCKER_IMAGE} .
```

## Run DSRS Spark container

To run a container you must know the name of the image or hash of the image. If you followed the Pull instructions aforementioned, the name is `sysstacks/dsrs-spark-centos:latest` for MKL-based image, and `sysstacks/dsrs-spark-centos:latest-oss` for OpenBLAS-based image. The hash can be retrieved along with all imported images with the command:

```bash
docker images
```

Now that you know the name of the image, you can run it:

```bash
docker run --ulimit nofile=1000000:1000000 --name <container name> --network host --rm -i -t sysstacks/dsrs-spark-centos:latest bash
```

or if you need to provide volume mappings as per your machines directory paths:

```bash
docker run --ulimit nofile=1000000:1000000 --name <container name> -v /data/datad:/mnt/disk1/spark/mkl -v /data/datae:/mnt/disk2/spark/mkl --network host --rm -i -t sysstacks/dsrs-spark-centos:latest
```

Please note that `/data/datad` and `/data/datae` are directories on the host machine while `/mnt/disk1/spark/mkl`, `/mnt/disk2/spark/mkl` are the mount points inside the container in the form of directories and are created on demand if they do not exist yet.
Also, for simplicity we provided --network as host, so host machine IP itself can be used to access container.


## Single node script configuration for Spark, Hadoop and Yarn
>>>
This script provides a basic configuration for running all Spark, Hadoop and Yarn services on a single container, for advanced configuration you can manually modify the configuration files or modify the templates located under `conf` directory in the repository. Once your modifications are done, you can proceed to rebuild the container image with your customizations.
>>>

To start a single node Hadoop and Spark cluster just run inside the container:

```bash
sudo /usr/local/sbin/start-single-node-analytics.sh
``` 

To start a spark-shell session with Intel MKL enabled
```bash
spark-shell-mkl.sh
```

To start a spark-shell session with OpenBLAS enabled
```bash
spark-shell-openblas.sh
```

If you need to configure spark-submit or pyspark for using the included BLAS libraries you can replicate the client configuration of spark-shell.

## Multinode cluster script configuration for Spark, Hadoop and Yarn
>>>
This script provides a basic configuration for running a cluster with Spark, Hadoop and Yarn services enabled, for advanced configuration you can manually modify the configuration files or modify the templates located under `conf` directory in the repository. Once your modifications are done, you can proceed to rebuild the container image with your customizations.
>>>

A simple multinode cluster configuration can be achieved using the built in script `setup-cluster-node.sh`, the first step is to create three containers: master-1,worker-1 and worker-2.

```bash
docker run -it -d -h master-1 --ip 172.17.0.2 --name master-1 <docker-image>
docker run -it -d -h worker-1 --ip 172.17.0.3 --name worker-1 <docker-image>
docker run -it -d -h worker-2 --ip 172.17.0.4 --name worker-2 <docker-image>
```

Then we need to log in to the master.

```bash
docker exec -it master-1 bash
```

The master and workers should be passed as a hostname and IP address pair separated by commas, to separate multiple workers we use `:`. This script automatically creates a simple configuration for the yarn cluster and also creates the required entries on `/etc/hosts`.

```bash
[analytics@master-1 /]$ setup-cluster-node.sh -m "master-1,172.17.0.2" -w "worker-1,172.17.0.3:worker-2,172.17.0.4"
```

The output should be the following:

```bash
Master hostname: master-1 Master IP: 172.17.0.2
Worker hostname: worker-1 Worker IP: 172.17.0.3
Worker hostname: worker-2 Worker IP: 172.17.0.4
/etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.2	master-1
172.17.0.2   master-1
172.17.0.3   worker-1
172.17.0.4   worker-2
+ /usr/bin/ssh-keygen -A
ssh-keygen: generating new host keys: RSA DSA ECDSA ED25519 
+ /usr/sbin/sshd
+ rm -rf /run/nologin
+ su - analytics -c 'echo -e '\''\n'\'' | ssh-keygen -N '\'''\'' '
Generating public/private rsa key pair.
Enter file in which to save the key (/home/analytics/.ssh/id_rsa): Created directory '/home/analytics/.ssh'.
Your identification has been saved in /home/analytics/.ssh/id_rsa.
Your public key has been saved in /home/analytics/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:dHCSvm67bbyJ45J3+DxAE9TvWlPx2tKo4/d4zeQVV6M analytics@master-1
The key's randomart image is:
+---[RSA 3072]----+
|       .+o.      |
|        o+.   ...|
|       .....  .oo|
|       .+.  .E..o|
|       .So . . =o|
|        o   + + =|
|       o + o o =o|
|      o *+*.o ..=|
|       ==B*+.o.o.|
+----[SHA256]-----+
+ su - analytics -c 'cp /home/analytics/.ssh/id_rsa.pub /home/analytics/.ssh/authorized_keys'
+ echo 'A SSH key was generated and added to /home/analytics/.ssh/authorized_keys'
A SSH key was generated and added to /home/analytics/.ssh/authorized_keys
Master SSH pubkey not provided, you should add your pubkey manually on /home/analytics/.ssh/authorized_keys
```

After running the script without `-k` flag a SSH key is autogenerated on the host, we need the pubkey to distribute it to the workers, we can get that pubkey in the following way:

```bash
[analytics@master-1 ~]$ cat /home/analytics/.ssh/authorized_keys 
```

Then we log in to worker-1, the same procedure applies to worker-2

```bash
docker exec -it worker-1 bash
```

We proceed to execute the script adding the master-1 ssh pubkey with the flag `-k`:

```bash
setup-cluster-node.sh -m "master-1,172.17.0.2" -w "worker-1,172.17.0.3:worker-2,172.17.0.4" -k "<master-ssh-pubkey>"
```

The output is the following.

```bash
Master hostname: master-1 Master IP: 172.17.0.2
Worker hostname: worker-1 Worker IP: 172.17.0.3
Worker hostname: worker-2 Worker IP: 172.17.0.4
/etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.4	worker-2
172.17.0.2   master-1
172.17.0.3   worker-1
172.17.0.4   worker-2
+ /usr/bin/ssh-keygen -A
ssh-keygen: generating new host keys: RSA DSA ECDSA ED25519 
+ /usr/sbin/sshd
+ rm -rf /run/nologin
+ su - analytics -c 'echo -e '\''\n'\'' | ssh-keygen -N '\'''\'' '
Generating public/private rsa key pair.
Enter file in which to save the key (/home/analytics/.ssh/id_rsa): Created directory '/home/analytics/.ssh'.
Your identification has been saved in /home/analytics/.ssh/id_rsa.
Your public key has been saved in /home/analytics/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:AansuG46hKg8WZNp16DNUeGYI2S96kQ9gFHvVWNqm3k analytics@worker-2
The key's randomart image is:
+---[RSA 3072]----+
| .++. .o.+       |
| .o...=o+ .      |
|   oo*o=.        |
|   .=*+ +.       |
|o .oB.=+SE       |
|o..X.+ ..        |
|+ *.o            |
|o+o.             |
|.=o              |
+----[SHA256]-----+
+ su - analytics -c 'cp /home/analytics/.ssh/id_rsa.pub /home/analytics/.ssh/authorized_keys'
+ echo 'A SSH key was generated and added to /home/analytics/.ssh/authorized_keys'
A SSH key was generated and added to /home/analytics/.ssh/authorized_keys
Added provided Master SSH pubkey to /home/analytics/.ssh/authorized_keys
```

Once worker-1 and worker-2 are configured as described, we need to log in to master-1 again.

```bash
docker exec -it master-1 bash
```

We need to start the hadoop services on the master, and the master proceeds to start the required services on the workers using SSH.

```bash
hdfs namenode -format
start-dfs.sh 
start-yarn.sh
```

To Verify the workers are properly joined to the cluster, we need to verify the status of HDFS service. It should display two working datanodes.

```bash
[analytics@master-1 /]$ hdfs dfsadmin -report
Configured Capacity: 449600987136 (418.72 GB)
Present Capacity: 349333528576 (325.34 GB)
DFS Remaining: 349333479424 (325.34 GB)
DFS Used: 49152 (48 KB)
DFS Used%: 0.00%
Replicated Blocks:
	Under replicated blocks: 0
	Blocks with corrupt replicas: 0
	Missing blocks: 0
	Missing blocks (with replication factor 1): 0
	Low redundancy blocks with highest priority to recover: 0
	Pending deletion blocks: 0
Erasure Coded Block Groups: 
	Low redundancy block groups: 0
	Block groups with corrupt internal blocks: 0
	Missing block groups: 0
	Low redundancy blocks with highest priority to recover: 0
	Pending deletion blocks: 0

-------------------------------------------------
Live datanodes (2):

Name: 172.17.0.3:9866 (worker-1)
Hostname: worker-1
Decommission Status : Normal
Configured Capacity: 224800493568 (209.36 GB)
DFS Used: 24576 (24 KB)
Non DFS Used: 40513658880 (37.73 GB)
DFS Remaining: 174666739712 (162.67 GB)
DFS Used%: 0.00%
DFS Remaining%: 77.70%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 1
Last contact: Fri Aug 21 18:45:39 UTC 2020
Last Block Report: Fri Aug 21 18:44:03 UTC 2020
Num of Blocks: 0


Name: 172.17.0.4:9866 (worker-2)
Hostname: worker-2
Decommission Status : Normal
Configured Capacity: 224800493568 (209.36 GB)
DFS Used: 24576 (24 KB)
Non DFS Used: 40513658880 (37.73 GB)
DFS Remaining: 174666739712 (162.67 GB)
DFS Used%: 0.00%
DFS Remaining%: 77.70%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 1
Last contact: Fri Aug 21 18:45:39 UTC 2020
Last Block Report: Fri Aug 21 18:44:03 UTC 2020
Num of Blocks: 0

```

The same applies for YARN

```bash
[analytics@master-1 /]$ yarn node -list
2020-08-21 18:47:22,919 INFO client.RMProxy: Connecting to ResourceManager at master-1/172.17.0.2:8032
Total Nodes:2
         Node-Id	     Node-State	Node-Http-Address	Number-of-Running-Containers
  worker-1:41987	        RUNNING	    worker-1:8042	                           0
  worker-2:35023	        RUNNING	    worker-2:8042	                           0

```

To perform a word count example against the cluster we need to put some text files on HDFS on the /input directory
and then call the wordcount example and specify we want the output to be written on /output as following:

```bash
hdfs dfs -mkdir /input
hdfs dfs -put /opt/hadoop-3.2.0/*.txt /input
yarn jar /opt/hadoop-3.2.0/share/hadoop/mapreduce/hadoop-mapreduce-examples*.jar  wordcount /input /output
hdfs dfs -cat /output/*
```

To perfom a Pi calculation example against the Yarn cluster:

```bash
yarn jar /opt/hadoop-3.2.0/share/hadoop/mapreduce/hadoop-mapreduce-examples*.jar  pi 10 1000
```

We can also submit Spark jobs to the Yarn cluster in client mode:

```bash
spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client --driver-memory 4g --executor-memory 2g --executor-cores 1 /opt/spark-3.0.0/examples/target/original-spark-examples_2.12-3.0.0.jar 10
```

Or cluster mode

```bash
spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --driver-memory 4g --executor-memory 2g --executor-cores 1 /opt/spark-3.0.0/examples/target/original-spark-examples_2.12-3.0.0.jar 10
```

When Performing computations we can see Yarn nodes reporting containers running.

```bash
[analytics@master-1 /]$ yarn node -list
2020-08-21 19:04:05,759 INFO client.RMProxy: Connecting to ResourceManager at master-1/172.17.0.2:8032
Total Nodes:2
         Node-Id	     Node-State	Node-Http-Address	Number-of-Running-Containers
  worker-1:41987	        RUNNING	    worker-1:8042	                           1
  worker-2:35023	        RUNNING	    worker-2:8042	                           2

```

Now the cluster is up and running if you want to use the built in BLAS libraries you can start a spark-shell session with Intel MKL enabled
```bash
spark-shell-mkl.sh
```

Or with OpenBLAS enabled
```bash
spark-shell-openblas.sh
```

If you need to configure spark-submit or pyspark for using the included BLAS libraries you can replicate the client configuration of spark-shell.


## Manual configuration
If you want to manually configure the analytics services inside the containers you can log in as root to an existing container in the following way:

```bash
docker exec -it -u root <container-id> bash
```

Once logged in you can modify everything on the container to fulfill your needs. Spark and Hadoop related files are under `/opt` directory.

## Reporting Security Issues

If you have discovered potential security vulnerability in an Intel product,
please contact the iPSIRT at secure@intel.com.

It is important to include the following details:

  * The products and versions affected
  * Detailed description of the vulnerability
  * Information on known exploits

Vulnerability information is extremely sensitive. The iPSIRT strongly recommends
that all security vulnerability reports sent to Intel be encrypted using the
iPSIRT PGP key. The PGP key is available here:
https://www.intel.com/content/www/us/en/security-center/pgp-public-key.html

Software to encrypt messages may be obtained from:

  * PGP Corporation
  * GnuPG

For more information on how Intel works to resolve security issues, see:
[Vulnerability handling
guidelines](https://www.intel.com/content/www/us/en/security-center/vulnerability-handling-guidelines.html)

## LEGAL NOTICE
By accessing, downloading or using this software and any required dependent software (the “Software Package”), you agree to the terms and conditions of the software license agreements for the Software Package, which may also include notices, disclaimers, or license terms for third party software included with the Software Package. Please refer to the “third-party-programs.txt” or other similarly-named text file for additional details.

*Intel and the Intel logo are trademarks of Intel Corporation or its
subsidiaries*

*\*Other names and brands may be claimed as the property of others*

