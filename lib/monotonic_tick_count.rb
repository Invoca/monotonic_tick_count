# frozen_string_literal: true

require "monotonic_tick_count/version"
require "active_support"
require "active_support/core_ext"

class MonotonicTickCount
  include Comparable

  # the tick count in seconds as floating point at nanosecond granularity
  attr_reader :tick_count_f

  # initialize from one of:
  #   - another object of this type OR
  #   - an equivalent object that responds to tick_count_f OR
  #   - an explicit keyword value of tick_count_f: which is a floating point count of seconds with fractional second at nanosecond granularity
  def initialize(other = nil, tick_count_f: nil)
    @tick_count_f = if other
                      other.respond_to?(:tick_count_f) or raise ArgumentError, "Must initialize from #{self.class} or equivalent"
                      other.tick_count_f
                    else
                      tick_count_f or raise ArgumentError, "Must provide either other or tick_count_f:"
                    end
  end

  def inspect
    "monotonic tick count #{@tick_count_f}"
  end

  # returns the difference from the other tick count and this tick count
  # as an ActiveSupport::Duration
  def -(other)
    other.respond_to?(:tick_count_f) or raise ArgumentError, "Other operand must be a #{self.class} or equivalent"
    (@tick_count_f - other.tick_count_f).seconds
  end

  def +(other)
    other.respond_to?(:from_now) or raise ArgumentError, "Other operand must be an ActiveSupport::Duration or equivalent"
    self.class.new(tick_count_f: @tick_count_f + other.to_f)
  end

  def <=>(other)
    other.respond_to?(:tick_count_f) or raise ArgumentError, "Other operand must be a #{self.class} or equivalent"
    @tick_count_f <=> other.tick_count_f
  end

  def hash
    @tick_count_f.hash
  end

  alias eql? ==

  class << self
    def now
      new(tick_count_f: Process.clock_gettime(Process::CLOCK_MONOTONIC))
    end
  end
end
