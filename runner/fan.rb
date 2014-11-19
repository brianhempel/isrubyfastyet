class Fan
  SMC_COMMAND = "/Applications/smcFanControl.app/Contents/Resources/smc"

  class << self
    def available?
      File.exists?(SMC_COMMAND)
    end

    def fans
      @fans ||= (0..9).map { |i| Fan.new(i) }.compact
    end

    def new(i)
      if Fan.min_speed(i)
        super
      else
        nil
      end
    end

    def read_property(i, property)
      if available?
        #  F0Mn  [fpe2]  2500 (bytes 27 10)
        `#{SMC_COMMAND} -k F#{i}#{property} -r` =~ /\]\s+([0-9\.]+)\s+\(bytes (.+)\)/
        [$1.to_i, $2.gsub(/\s+/, '')] if $1 && $2
      end
    end

    def min_speed(i)
      read_property(i, 'Mn')
    end

    def max_speed(i)
      read_property(i, 'Mx')
    end

    def actual_speed(i)
      read_property(i, 'Ac')
    end

    def set_min_speed(i, bytes)
      `#{SMC_COMMAND} -k F#{i}Mn -w #{bytes}` if available?
    end

    def maximize_all!
      fans.each(&:maximize_speed!)
    end

    def return_all_to_normal!
      fans.each(&:original_speed!)
    end
  end

  attr_reader :index, :original_min_speed, :original_min_speed_bytes, :max_speed, :max_speed_bytes

  def initialize(i)
    @index = i
    @original_min_speed, @original_min_speed_bytes = Fan.min_speed(i)
    @max_speed, @max_speed_bytes                   = Fan.max_speed(i)
  end

  def maximize_speed!
    Fan.set_min_speed(index, max_speed_bytes)
  end

  def original_speed!
    Fan.set_min_speed(index, original_min_speed_bytes)
  end

  def actual_speed
    Fan.actual_speed(index)[0]
  end
end

if !Fan.available?
  puts "Fan control not available...#{Fan::SMC_COMMAND} not found!"
end