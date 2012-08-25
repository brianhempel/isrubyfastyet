class this.Ruby
  constructor: (@rvm_name, @color) ->

Ruby.rubies =
  "1.8.7":      new Ruby("1.8.7",      "#aa0000"),
  "1.8.7-head": new Ruby("1.8.7-head", "#ff0000"),
  "1.9.2":      new Ruby("1.9.2",      "#888800"),
  "1.9.2-head": new Ruby("1.9.2-head", "#dddd00"),
  "1.9.3":      new Ruby("1.9.3",      "#009900"),
  "1.9.3-head": new Ruby("1.9.3-head", "#00ee00"),
  "ruby-head":  new Ruby("ruby-head",  "#ff7766"),
  "jruby":      new Ruby("jruby",      "#000099"),
  "jruby-head": new Ruby("jruby-head", "#0000ff"),
  "rbx-head":   new Ruby("rbx-head",   "#ead4c3")

Ruby.ruby_names = (name for name, ruby of Ruby.rubies)
