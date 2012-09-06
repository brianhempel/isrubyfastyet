Pivotal Tracker project: [https://www.pivotaltracker.com/projects/439755](https://www.pivotaltracker.com/projects/439755)

[Google search frequencies](http://www.google.com/insights/search/#q=ruby%20benchmark%2Cruby%20speed%2Cpython%20speed%2Cruby%20language%2Cruby%20tutorial&cmpt=q)

- "ruby speed" is 1/8 as popular as "ruby tutorial"
- "ruby speed" is 1/5 as popular as "ruby language"
- "ruby speed" is 1/2 as popular as "python speed"

### Usage

```
# run the benchmark (~3.5 hours on my box, more for the first run)
cd runner
rake

# see how the latest results compare to the median of the 5 previous
# (cd to project root...not runner)
rake variability
```

### Tests

```
# to test the shared models
gem install rspec
rspec spec /

# to test the front-end app
cd isrubyfastyet.com
bundle install
rspec spec/
```