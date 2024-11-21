from pyspark.sql import SparkSession

def map_bigrams_per_line(line):
    """
    تولید جفت کلمات (bigram) از یک خط
    """
    # حذف فاصله‌های اضافی و تبدیل به حروف کوچک
    words = line.strip().lower().split()
    # تولید جفت کلمات (bigram) برای هر خط
    return [(f"{words[i]} {words[i+1]}", 1) for i in range(len(words) - 1)]

def reduce_counts(count1, count2):
    """
    جمع زدن تعداد تکرار جفت کلمات
    """
    return count1 + count2

def main():
    # ایجاد SparkSession
    spark = SparkSession.builder.appName("BigramCount").getOrCreate()

    # مسیر فایل ورودی و خروجی
    input_path = "hdfs://localhost:9000/input/test.txt"
    output_path = "hdfs://localhost:9000/output_bigrams"

    # خواندن فایل ورودی خط به خط
    text_rdd = spark.sparkContext.textFile(input_path)

    # تولید جفت کلمات و شمارش آن‌ها
    bigram_counts = (
        text_rdd
        .flatMap(map_bigrams_per_line)  # جفت کلمات (bigram) خط به خط
        .reduceByKey(reduce_counts)    # جمع زدن تعداد تکرار هر جفت کلمه
    )

    # ذخیره خروجی در HDFS
    bigram_counts.coalesce(1).saveAsTextFile(output_path)

    # خاتمه SparkSession
    spark.stop()

if __name__ == "__main__":
    main()
