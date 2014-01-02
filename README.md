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
# run the benchmark (~3.5 hours on my box, more for the first run)
cd runner
rake

# see how the latest results compare to the median of the 5 previous
rake variability
```

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
