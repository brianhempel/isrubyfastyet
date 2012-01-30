class Ruby

  attr_reader :name, :rvm_name

  def initialize(attrs={})
    @name     = attrs[:name]
    @rvm_name = attrs[:rvm_name]
  end

  class << self
    attr_accessor :rubies_file_path

    def all_stable
      all.select { |ruby| ruby.rvm_name !~ /-head/ }
    end

    def all
      rows = File.read(rubies_file_path).lines.map(&:chomp).select { |line| line !~ /^\s*#/ }.map { |line| line.split(/\s\s+/) }

      headers = rows.shift

      rows.map do |row|
        {}.tap do |hash|
          row.each_with_index do |cell, i|
            hash.merge!(headers[i] => cell)
          end
        end
      end.map do |row_hash|
        new(:name => row_hash['Nice Name'], :rvm_name => row_hash['RVM Name'])
      end
    end
  end

end