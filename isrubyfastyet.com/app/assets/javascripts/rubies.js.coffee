class this.Ruby
  constructor: (@rvm_name, @color) ->

Ruby.rubies =
  "1.8.7":      new Ruby("1.8.7",      "#aa0000"),
  "1.8.7-head": new Ruby("1.8.7-head", "#ff0000"),
  "1.9.2":      new Ruby("1.9.2",      "#888800"),
  "1.9.2-head": new Ruby("1.9.2-head", "#dddd00"),
  "1.9.3":      new Ruby("1.9.3",      "#009900"),
  "1.9.3-head": new Ruby("1.9.3-head", "#00ee00"),
  "2.0.0":      new Ruby("2.0.0",      "#7700b8"),
  "2.0.0-head": new Ruby("2.0.0-head", "#cd88e0"),
  "2.1.0":      new Ruby("2.1.0",      "#778888"),
  "2.1.0-head": new Ruby("2.1.0-head", "#aabbbb"),
  "2.1":        new Ruby("2.1",        "#778888"),
  "2.1-head":   new Ruby("2.1-head",   "#aabbbb"),
  "ruby-head":  new Ruby("ruby-head",  "#330000"),
  "jruby":      new Ruby("jruby",      "#000099"),
  "jruby-head": new Ruby("jruby-head", "#0000ff"),
  "rbx":        new Ruby("rbx",        "#d7c1b0"),
  "rbx-head":   new Ruby("rbx-head",   "#ead4c3")

Ruby.ruby_names = (name for name, ruby of Ruby.rubies)
