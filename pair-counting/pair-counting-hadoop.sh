#Pair Counting with hadoop Output: ((w1, W2), x)

#1. Initialize Project dir 
mkdir ~/bigram_project
cd ~/bigram_project

nano BigramCount.java
##Copy the code and paste & Save & Quit

#2. Compile Java
javac -classpath `hadoop classpath` -d . BigramCount.java

#3. Create jar file
jar -cvf bigramcount.jar -C . .

#4. Create test.txt and upload in HDFS
touch test.txt
nano test.txt
##Copy the text and paste & Save & Quit

hadoop fs -mkdir /input

hadoop fs -put test.txt /input

hadoop fs -ls /input
#You must just see test.txt. if there is other file remove them... => hadoop fs -rm /input/example.txt

#5. Remove /output
hadoop fs -rm -r /output

#6. Run the MapReduce
hadoop jar bigramcount.jar BigramCount /input /output

hadoop fs -cat /output/part-r-00000
#Output:
counting with	1
hadoop hello	2
hadoop mapreduce	1
hello hadoop	6
is amazing	1
is pair	1
is powerful	5
mapreduce is	6
pair counting	1
powerful mapreduce	1
program is	1
this program	1
with hadoop	1

