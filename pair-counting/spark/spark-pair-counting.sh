#Pair Counting with Spark Output: ((w1, W2), x)

#1. Initialize Project dir 
mkdir ~/spark_bigrams
cd ~/spark_bigrams

nano bigram.py
##Copy the code and paste & Save & Quit

#2. Upload in HDFS
hadoop fs -put test.txt /input

hadoop fs -ls /input
#You must just see test.txt. if there is other file remove them... => hadoop fs -rm /input/example.txt

#3. Run the code
spark-submit bigram_count.py

#4. See Output:
hadoop fs -ls /output_bigrams
hadoop fs -cat /output_bigrams/part-00000
#Output:
('mapreduce is', 6)
('is powerful', 5)
('with hadoop', 1)
('hadoop hello', 2)
('hello hadoop', 6)
('hadoop mapreduce', 1)
('is amazing', 1)
('this program', 1)
('program is', 1)
('is pair', 1)
('pair counting', 1)
('counting with', 1)
('powerful mapreduce', 1)