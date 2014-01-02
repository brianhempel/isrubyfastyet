View the site: [www.isrubyfastyet.com](http://www.isrubyfastyet.com/)

[Google search frequencies](http://www.google.com/insights/search/#q=ruby%20benchmark%2Cruby%20speed%2Cpython%20speed%2Cruby%20language%2Cruby%20tutorial&cmpt=q)

- "ruby speed" is 1/8 as popular as "ruby tutorial"
- "ruby speed" is 1/5 as popular as "ruby language"
- "ruby speed" is 1/2 as popular as "python speed"

### Dependencies

You need the `gtimeout` command from GNU Coreutils. Easy peasy with Homebrew on OS X.

```
brew install coreutils
```

You also need phantomjs if you would like to transform the Rails frontend to a static site.

```
brew install phantomjs
```

### Usage

```
# run the entire benchmark suite (~3.5 hours on my box, more for the first run)
cd runner
rake

# see how the latest results compare to the median of the 5 previous
rake variability
```

The individual benchmarks are simply Ruby files in runner/benchmarks ending with *benchmark.rb. If you want to run a benchmark individually...

```
# switch to the ruby version you want
rvm jruby-head

# navigate to the benchmark folder
cd runner/benchmarks/rails
# you may have to do some bundling here (not shown)
# then simply execute the benchmark
ruby requests_per_second_benchmark.rb
```

Writing a new benchmark is easy. Simply author a new file in the benchmarks folder, such as "benchmarks/pure_ruby_gzip/compression_benchmark.rb", and make sure the last line to standard out is the benchmark result with units, like `123456 KB compressed per second`.

### Tests

Tests need Ruby >= 1.9, though the benchmark suite can run under 1.8.7.

```
# to test the front-end app
cd isrubyfastyet.com
bundle install
rspec spec/

# to test the shared models
gem install rspec
rspec spec/
```
