require 'spec_helper'

describe Ruby do
  describe "#name" do
    it "returns the name given on initialization" do
      ruby = Ruby.new(:name => "Awesome Ruby")
      ruby.name.should == "Awesome Ruby"
    end
  end

  describe "#rvm_name" do
    it "returns the RVM name given on initialization" do
      ruby = Ruby.new(:rvm_name => "1.8.7-head")
      ruby.rvm_name.should == "1.8.7-head"
    end
  end

  describe ".all" do
    before do
      @rubies_file = Tempfile.new('rubies')
      @rubies_file.write(<<-RUBIES)
Nice Name         RVM Name         Command
MRI 1.8.7 Stable  1.8.7            ruby
JRuby Head        jruby-head       jruby -S
# MacRuby Nightly   macruby-nightly  ruby
      RUBIES
      @rubies_file.close
      Ruby.rubies_file_path = @rubies_file.path
    end

    it "returns the right number of rubies" do
      Ruby.all.count == 2
    end

    it "initializes the names correctly" do
      ruby_names = Ruby.all.map(&:name)
      ruby_names.should include("MRI 1.8.7 Stable")
      ruby_names.should include("JRuby Head")
    end

    it "initializes the rvm names correctly" do
      rvm_names = Ruby.all.map(&:rvm_name)
      rvm_names.should include("1.8.7")
      rvm_names.should include("jruby-head")
    end

    it "returns the rubies in order" do
      ruby_names = Ruby.all.map(&:name)
      ruby_names.should == ["MRI 1.8.7 Stable", "JRuby Head"]
    end
  end
end