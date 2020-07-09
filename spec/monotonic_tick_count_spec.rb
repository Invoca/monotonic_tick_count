# frozen_string_literal: true

require "spec_helper"

describe MonotonicTickCount do
  it "should have a version number" do
    expect(::MonotonicTickCount::VERSION).to be
  end

  describe "#initialize" do
    it "should have a copy constructor" do
      tick_count1 = MonotonicTickCount.now
      tick_count2 = MonotonicTickCount.new(tick_count1)
      expect(tick_count2).to eq(tick_count1)
    end

    it "should be constructable from a raw tick_count_f" do
      tick_count = MonotonicTickCount.new(tick_count_f: 112233.4455)
      expect(tick_count.tick_count_f).to eq(112233.4455)
    end

    it "should raise an exception if neither initialize arguemnt is passed" do
      expect { MonotonicTickCount.new }.to raise_error(ArgumentError, "Must provide either other or tick_count_f:")
    end

    it "should raise an exception if first initialize arguemnts is nil" do
      expect { MonotonicTickCount.new(nil) }.to raise_error(ArgumentError, "Must provide either other or tick_count_f:")
    end

    it "should raise an exception if both initialize arguemnts are nil" do
      expect { MonotonicTickCount.new(nil, tick_count_f: nil) }.to raise_error(ArgumentError, "Must provide either other or tick_count_f:")
    end

    it "should raise an exception from copy constructor if other isn't same class or equivalent" do
      expect { MonotonicTickCount.new(1122.33) }.to raise_error(ArgumentError, "Must initialize from MonotonicTickCount or equivalent")
    end
  end

  describe "#-" do
    before do
      @tick_count1 = MonotonicTickCount.new(tick_count_f: 123.1)
    end

    it "should return the difference between two tick counts in seconds" do
      tick_count2 = MonotonicTickCount.new(tick_count_f: 125.6)
      difference = tick_count2 - @tick_count1
      expect(difference).to eq(2.5)
    end

    it "should return a negative offset for a duration rhs" do
      tick_count2 = @tick_count1 - 23.1.seconds
      expect(tick_count2.is_a? MonotonicTickCount).to be true
      expect(tick_count2.tick_count_f).to eq(100.0)
    end

    it "should return a negative offset for a numeric rhs" do
      tick_count2 = @tick_count1 - 23.1
      expect(tick_count2.is_a? MonotonicTickCount).to be true
      expect(tick_count2.tick_count_f).to eq(100.0)
    end

    it "should raise an exception if other isn't the same class or does not respond to to_f" do
      expect { @tick_count1 - Object.new }.to raise_error(ArgumentError, "Other operand must be another MonotonicTickCount or respond to to_f")
    end
  end

  describe "#+" do
    before do
      @tick_count = MonotonicTickCount.new(tick_count_f: 123.1)
    end

    it "should support adding a duration" do
      duration = 2.5.seconds
      sum = @tick_count + duration
      expect(sum.tick_count_f).to eq(125.6)
    end

    it "should support adding a numeric" do
      sum = @tick_count + 2.5
      expect(sum.tick_count_f).to eq(125.6)
    end

    it "should support adding anything that responds to to_f" do
      obj = Object.new.tap { |obj| allow(obj).to receive(:to_f) { 2.5 } }
      sum = @tick_count + obj
      expect(sum.tick_count_f).to eq(125.6)
    end

    it "should raise an exception if rhs does not respond to to_f" do
      expect { @tick_count + Object.new }.to raise_error(ArgumentError, "Other operand must respond to to_f")
    end
  end

  describe "Comparable" do
    before do
      @tick_count1 = MonotonicTickCount.new(tick_count_f: 1.1)
      @tick_count2 = MonotonicTickCount.new(tick_count_f: 2.2)
    end

    it "should support >" do
      expect(@tick_count2).to be > @tick_count1
    end

    it "should support <=" do
      expect(@tick_count1).to be <= @tick_count2
    end

    it "should support ==" do
      expect(@tick_count1).to be == @tick_count1
    end

    it "should raise an exception if other isn't the same class or equivalent" do
      tick_count1 = 123.1
      tick_count2 = MonotonicTickCount.new(tick_count_f: 125.6)
      expect { tick_count2 > tick_count1 }.to raise_error(ArgumentError, "Other operand must be a MonotonicTickCount or equivalent")
    end
  end

  describe "#hash" do
    it "should delegate hash to tick_count_f" do
      tick_count1 = MonotonicTickCount.new(tick_count_f: 1.1)
      tick_count2 = MonotonicTickCount.new(tick_count_f: 1.1)

      expect(tick_count1.hash).to eq(tick_count2.hash)
    end

    it "should delegate eql? to tick_count_f" do
      tick_count1 = MonotonicTickCount.new(tick_count_f: 1.1)
      tick_count2 = MonotonicTickCount.new(tick_count_f: 1.1)

      expect(tick_count2.eql?(tick_count1)).to be true
    end

    it "should allow tick counts to be Hash keys" do
      tick_count1 = MonotonicTickCount.new(tick_count_f: 1.1)
      tick_count2 = MonotonicTickCount.new(tick_count_f: 1.1)
      tick_count3 = MonotonicTickCount.new(tick_count_f: 3.3)

      hash = {}
      hash[tick_count1] = :one
      hash[tick_count2] = :two  # should overwrite above since same key value
      hash[tick_count3] = :three

      expect(hash.to_a).to eq([[MonotonicTickCount.new(tick_count_f: 1.1), :two], [MonotonicTickCount.new(tick_count_f: 3.3), :three]])
    end
  end

  describe "#inspect" do
    it "should identify itself and have the tick count" do
      expect(Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC) { 1234.012345 }
      tick_count = MonotonicTickCount.now
      expect(tick_count.inspect).to eq("monotonic tick count 1234.012345")
    end
  end

  context "class methods" do
    describe ".now" do
      it "should return an instance containing the current global monotonic tick counter" do
        expect(Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC) { 1234.012345 }
        tick_count = MonotonicTickCount.now
        expect(tick_count.tick_count_f).to eq(1234.012345)
      end
    end

    describe ".timer" do
      it "should return the result and elapsed seconds of the given block" do
        expect(MonotonicTickCount).to receive(:now).and_return(0.0, 2.718)
        result, duration = MonotonicTickCount.timer { 1 }
        expect(result).to be == 1
        expect(duration).to be == 2.718
      end

      it "yields the start_tick to the block" do
        allow(MonotonicTickCount).to receive(:now).and_return(1.234)
        MonotonicTickCount.timer do |start_tick|
          expect(start_tick).to eq(1.234)
        end
      end
    end
  end
end
