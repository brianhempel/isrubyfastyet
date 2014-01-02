require 'spec_helper'

describe BenchmarkResultSet::Result do
  describe ".new" do
    it "takes a time string, an RVM name, a value with units, and a version string and stores them" do
      result = BenchmarkResultSet::Result.new("2012-01-30 09:31:21 UTC", "jruby", "192.88535118103 MB", "jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]")
      result.time_str.should         == "2012-01-30 09:31:21 UTC"
      result.rvm_name.should         == "jruby"
      result.value_with_units.should == "192.88535118103 MB"
      result.version_string.should   == "jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]"
    end
  end

  describe "#full_version" do
    it "is the same as version_string" do
      result = BenchmarkResultSet::Result.new(nil, nil, nil, "alphabet soup")
      result.full_version.should == "alphabet soup"
    end
  end

  describe "#to_f, #result, and #value" do
    it "returns a float of the result if there's a result" do
      result = BenchmarkResultSet::Result.new(nil, nil, "123.45 MB", nil)
      result.to_f.should be_within(0.01).of(123.45)
      result.result.should be_within(0.01).of(123.45)
      result.value.should be_within(0.01).of(123.45)
    end

    it "returns nil on failed result" do
      result = BenchmarkResultSet::Result.new(nil, nil, "failed", nil)
      result.to_f.should be_nil
      result.result.should be_nil
      result.value.should be_nil
    end
  end

  describe "#success?" do
    it "returns true if the benchmark run produced a result" do
      result = BenchmarkResultSet::Result.new(nil, nil, "123.45 MB", nil)
      result.success?.should be_true
    end

    it "returns false if the benchmark run output 'failed'" do
      result = BenchmarkResultSet::Result.new(nil, nil, "failed", nil)
      result.success?.should be_false
    end

    it "returns false if the benchmark run output is empty" do
      result = BenchmarkResultSet::Result.new(nil, nil, "", nil)
      result.success?.should be_false
    end
  end

  describe "#units" do
    it "returns the units of a result" do
      result = BenchmarkResultSet::Result.new(nil, nil, "123 beaver pelts", nil)
      result.units.should == "beaver pelts"
    end

    it "returns nil on a failed result" do
      result = BenchmarkResultSet::Result.new(nil, nil, "failed", nil)
      result.units.should be_nil
    end
  end

  describe "#time" do
    it "returns a time object of the time" do
      result = BenchmarkResultSet::Result.new("2012-01-30 09:31:21 UTC", nil, nil, nil)
      result.time.should == Time.new(2012, 1, 30, 9, 31, 21, "+00:00")
    end
  end

  describe "#time_ms" do
    it "returns ms since the epoch" do
      result = BenchmarkResultSet::Result.new("2012-01-30 09:31:21 UTC", nil, nil, nil)
      result.time_ms.should == 1327915881000
    end
  end
end
