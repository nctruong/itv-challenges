# Specifying the columns, avoiding getting unused data.
Reference: [https://rails-bestpractices.com/posts/2010/10/19/select-specific-fields-for-performance/]
```ruby
User.select("name, (select count(id) from posts where posts.user_id=users.id) as post_count")
    .order("post_count desc")
```
# JOIN tables
Have a look at [https://dev.mysql.com/doc/refman/5.5/en/optimizing-subqueries.html]

Actually we can make it with JOIN and GROUP BY. The performance
between JOIN and Subquery depends on the number of rows, indices and the complexity of query.

This is solution with JOIN:

```
User.joins(:posts).select(:id).group(:id).order('count(posts.id) DESC')
```

Some demo Benchmark in real case:

```
[13] pry(main)> Benchmark.measure {  Evaluation.joins(:evaluation_items).select('id').group(:id).order('count(evaluation_items.id) DESC')}
=> #<Benchmark::Tms:0x00007ff67a74e438 @cstime=0.0, @cutime=0.0, @label="", @real=0.00014399999054148793, @stime=0.0, @total=0.0, @utime=0.0>

[14] pry(main)> Benchmark.measure { Evaluation.select("*, (select count(*) from evaluation_items where evaluations.id = evaluation_items.evaluation_id) as post_count").order("post_count desc") }
=> #<Benchmark::Tms:0x00007ff675fa6cc0 @cstime=0.0, @cutime=0.0, @label="", @real=0.0001449999981559813, @stime=0.0, @total=0.0, @utime=0.0>

[15] pry(main)> Benchmark.measure {  Evaluation.joins(:evaluation_items).select('id').group(:id).order('count(evaluation_items.id) DESC')}                => #<Benchmark::Tms:0x00007ff675f56658 @cstime=0.0, @cutime=0.0, @label="", @real=0.0001049999991664663, @stime=0.0, @total=0.0, @utime=0.0>

[16] pry(main)> Benchmark.measure { Evaluation.select("*, (select count(*) from evaluation_items where evaluations.id = evaluation_items.evaluation_id) as post_count").order("post_count desc") }
=> #<Benchmark::Tms:0x00007ff675f07080 @cstime=0.0, @cutime=0.0, @label="", @real=8.800000068731606e-05, @stime=0.0, @total=0.0, @utime=0.0>

[17] pry(main)> Benchmark.measure {  Evaluation.joins(:evaluation_items).select('id').group(:id).order('count(evaluation_items.id) DESC')}                => #<Benchmark::Tms:0x00007ff675eb69f0 @cstime=0.0, @cutime=0.0, @label="", @real=0.00010699999984353781, @stime=0.0, @total=0.0, @utime=0.0>

[18] pry(main)> Benchmark.measure { Evaluation.select("*, (select count(*) from evaluation_items where evaluations.id = evaluation_items.evaluation_id) as post_count").order("post_count desc") }
=> #<Benchmark::Tms:0x00007ff675e673a0 @cstime=0.0, @cutime=0.0, @label="", @real=8.50000069476664e-05, @stime=0.0, @total=0.0, @utime=0.0>

[19] pry(main)> Benchmark.measure {  Evaluation.joins(:evaluation_items).select('id').group(:id).order('count(evaluation_items.id) DESC')}                => #<Benchmark::Tms:0x00007ff675e16d10 @cstime=0.0, @cutime=0.0, @label="", @real=0.00010299999848939478, @stime=0.0, @total=0.0, @utime=0.0>

[20] pry(main)> Benchmark.measure { Evaluation.select("*, (select count(*) from evaluation_items where evaluations.id = evaluation_items.evaluation_id) as post_count").order("post_count desc") }
=> #<Benchmark::Tms:0x00007ff675dcf690 @cstime=0.0, @cutime=0.0, @label="", @real=0.00046299998939502984, @stime=0.0, @total=0.0, @utime=0.0>
```

# Pre-processing data
By create a new column name `num_of_post` and using callback of Post to update this value, we are preprocessing data. Thus, the query now would be like this.

```ruby
User.select(:id).order('num_of_post DESC')
```
If you are concerned about creating new column would slowdown POST or UPDATE data, we can use message queue to solve it like solution for counting page views.
