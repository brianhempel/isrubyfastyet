Pivotal Tracker project: [https://www.pivotaltracker.com/projects/439755](https://www.pivotaltracker.com/projects/439755)

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
cd isrubyfastyet/runner
rake

# see how the latest results compare to the median of the 5 previous
cd isrubyfastyet
rake variability
```

### Tests

```
# to test the front-end app
bundle install
rspec spec/

# to test the shared models
cd isrubyfastyet
gem install rspec
rspec spec/
```

### Trouble

You can't have rubygems-bundler installed because the ./isrubyfastyet/Rakefile shouldn't run under the ./Gemfile. You may have to uninstall rubygems-bundler by removing it from your ~/.rvm/gems directories manually.
