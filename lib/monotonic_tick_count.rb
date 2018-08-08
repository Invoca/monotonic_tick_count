require "monotonic_tick_count/version"
require "active_support"
require "active_support/core_ext"

class MonotonicTickCount
  include Comparable

  # the tick count in seconds as floating point at nanosecond granularity
  attr_reader :tick_count_f

  # initialize from one of:
  #   - no arguments--uses the system current_tick_count
  #   - another object of this type OR
  #   - an equivalent object that responds to tick_count_f OR
  #   - an explicit keyword value of tick_count_f: which is a floating point count of seconds with fractional second at nanosecond granularity
  def initialize(rhs = nil, tick_count_f: nil)
    @tick_count_f = if rhs
                      rhs.respond_to?(:tick_count_f) or raise ArgumentError, "Must initialize from #{self.class} or equivalent"
                      rhs.tick_count_f
                    elsif tick_count_f
                      tick_count_f
                    else
                      self.class.current_tick_count
                    end
  end

  def inspect
    "monotonic tick count #{@tick_count_f}"
  end

  # returns the difference from the rhs tick count and this tick count
  # as an ActiveSupport::Duration
  def -(rhs)
    rhs.respond_to?(:tick_count_f) or raise ArgumentError, "Other operand must be a #{self.class} or equivalent"
    (@tick_count_f - rhs.tick_count_f).seconds
  end

  def +(rhs)
    rhs.respond_to?(:from_now) or raise ArgumentError, "Other operand must be an ActiveSupport::Duration or equivalent"
    self.class.new(tick_count_f: @tick_count_f + rhs.to_f)
  end

  def <=>(rhs)
    rhs.respond_to?(:tick_count_f) or raise ArgumentError, "Other operand must be a #{self.class} or equivalent"
    @tick_count_f <=> rhs.tick_count_f
  end

  def hash
    @tick_count_f.hash
  end

  alias eql? ==


  class << self
    def current_tick_count
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
