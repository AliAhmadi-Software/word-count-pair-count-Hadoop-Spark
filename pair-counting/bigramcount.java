import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class BigramCount {

    public static class BigramMapper
        extends Mapper<Object, Text, Text, IntWritable> {

        private final static IntWritable one = new IntWritable(1);
        private Text bigram = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            // دریافت خط ورودی، تبدیل به حروف کوچک و حذف فاصله‌های اضافی
            String line = value.toString().toLowerCase().trim();

            // تقسیم خط به کلمات
            String[] words = line.split("\\s+");

            // تولید جفت کلمات (bigram)
            for (int i = 0; i < words.length - 1; i++) {
                String w1 = words[i];
                String w2 = words[i + 1];
                bigram.set(w1 + " " + w2); // جفت کلمه
                context.write(bigram, one);
            }
        }
    }

    public static class BigramReducer
        extends Reducer<Text, IntWritable, Text, IntWritable> {

        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "bigram count");
        job.setJarByClass(BigramCount.class);
        job.setMapperClass(BigramMapper.class);
        job.setCombinerClass(BigramReducer.class);
        job.setReducerClass(BigramReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
