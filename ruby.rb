require File.expand_path('../isrubyfastyet', __FILE__)

class Ruby < Struct.new(:rvm_name)
  def self.all_stable
    all.select { |ruby| ruby.rvm_name !~ /-head/ }
  end

  def self.all
    rows = File.read(irfy_path('runner/rubies')).lines.map(&:chomp).select { |line| line !~ /^\s*#/ }.map { |line| line.split(/\s\s+/) }

    headers = rows.shift

    rows.map do |row|
      {}.tap do |hash|
        row.each_with_index do |cell, i|
          hash.merge!(headers[i] => cell)
        end
      end
    end.map { |row_hash| new(row_hash['RVM Name']) }
  end
end