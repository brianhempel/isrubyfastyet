require 'spec_helper'

describe BenchmarkResultSet do
  before :all do
    begin Dir.mkdir(File.expand_path('../../tmp', __FILE__));         rescue Errno::EEXIST; end
    begin Dir.mkdir(File.expand_path('../../tmp/results', __FILE__)); rescue Errno::EEXIST; end
    @results_dir = File.expand_path('../../tmp/results', __FILE__)
    BenchmarkResultSet.results_dir = @results_dir
  end

  before do
    # remove result files
    Dir.glob(File.join(@results_dir, '*')).each { |path| File.unlink(path) }
  end

  def create_result_file(name, data)
    File.join(@results_dir, name).tap do |path|
      File.open(path, "w") { |f| f.write(data) }
    end
  end

  describe ".all" do
    before do
      create_result_file('benchmark_1_results.tsv', <<-BM)
2012-01-30 09:31:21 UTC	jruby	192.88535118103 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-01-30 10:01:50 UTC	jruby-head	212.03821579615274 MB	jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-01-30 60a764e) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-02-01 09:29:42 UTC	jruby	195.573979695638 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-02-01 14:59:00 UTC	jruby-head	failed	jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-02-01 84e3e3f) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java] 
      BM
      create_result_file('benchmark_2_results.tsv', <<-BM)
2012-01-30 09:31:21 UTC	jruby	192.88535118103 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-01-30 10:01:50 UTC	jruby-head	212.03821579615274 MB	jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-01-30 60a764e) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-02-01 09:29:42 UTC	jruby	195.573979695638 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-02-01 14:59:00 UTC	jruby-head	failed	jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-02-01 84e3e3f) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java] 
      BM
    end

    it "returns the right number of result sets" do
      BenchmarkResultSet.all.count.should == 2
    end

    it "returns result sets" do
      BenchmarkResultSet.all.map(&:class).uniq.should == [BenchmarkResultSet]
    end
  end

  describe BenchmarkResultSet::Result do
    before do
      @result = BenchmarkResultSet::Result.from_tsv_line("2012-01-30 09:31:21 UTC	jruby	192.88535118103 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]\n")
    end

    it "has rvm_name" do
      @result.rvm_name.should == "jruby"
    end

    it "has value_with_units" do
      @result.value_with_units.should == "192.88535118103 MB"
    end

    it "#to_f works" do
      @result.to_f.should be_within(0.001).of(192.88535118103)
    end

    it "#success? is true for a good result" do
      @result.success?.should be_true
    end

    context "failed result" do
      before do
        @failed_result = BenchmarkResultSet::Result.from_tsv_line("2012-01-30 09:31:21 UTC	jruby	failed asdf	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]\n")
      end

      it "#value_with_units falls through" do
        @failed_result.value_with_units.should == "failed asdf"
      end

      it "#success? is false" do
        @failed_result.success?.should be_false
      end

      it "#to_f returns nil on failure" do
        @failed_result.to_f.should be_nil
      end
    end
  end

  context "instance methods" do
    before do
      result_set_path = create_result_file('benchmark_1_results.tsv', <<-BM)
2012-01-30 09:31:21 UTC	jruby	192.88535118103 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-01-30 10:01:50 UTC	jruby-head	212.03821579615274 MB	jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-01-30 60a764e) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-02-01 09:29:42 UTC	jruby	195.573979695638 MB	jruby 1.6.5.1 (ruby-1.8.7-p330) (2011-12-27 1bf37c2) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
2012-02-01 14:59:00 UTC	jruby-head	failed	jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-02-01 84e3e3f) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java] 
      BM
      @result_set = BenchmarkResultSet.new(result_set_path)
    end

    it "#name returns the file name, minus _results.tsv" do
      @result_set.name.should == "benchmark_1"
    end

    describe "#all_results" do
      before do
        @all_results = @result_set.all_results
      end

      it "returns BenchmarkResultSet::Result objects" do
        @all_results.map(&:class).uniq.should == [BenchmarkResultSet::Result]
      end

      it "returns the right number of results" do
        @all_results.count.should == 4
      end

      it "intializes the results correctly, and in order" do
        expected_attributes = [
          ['jruby',      '192.88535118103 MB'   ],
          ['jruby-head', '212.03821579615274 MB'],
          ['jruby',      '195.573979695638 MB'  ],
          ['jruby-head', 'failed'               ]
        ]
        @all_results.map do |result|
          [result.rvm_name, result.value_with_units]
        end.should == expected_attributes
      end
    end

    describe "#results_by_rvm_name" do
      before do
        @jruby_results = @result_set.results_by_rvm_name('jruby')
      end

      it "returns BenchmarkResultSet::Result objects" do
        @jruby_results.map(&:class).uniq.should == [BenchmarkResultSet::Result]
      end

      it "returns the right number of results" do
        @jruby_results.count.should == 2
      end

      it "intializes the results correctly, and in order" do
        expected_attributes = [
          ['jruby',      '192.88535118103 MB'   ],
          ['jruby',      '195.573979695638 MB'  ],
        ]
        @jruby_results.map do |result|
          [result.rvm_name, result.value_with_units]
        end.should == expected_attributes
      end
    end
  end
end