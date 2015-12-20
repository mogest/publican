require_relative '../lib/publican'

RSpec.describe Publican do
  class Sample
    include Publican

    def fire(event, *args)
      publish(event, *args)
    end

    def fire!(event, *args)
      publish!(event, *args)
    end
  end

  let(:sample) { Sample.new }
  let(:tracker) { Struct.new(:ok, :count).new(false, 0) }

  def ok
    tracker.ok = true
    tracker.count += 1
  end

  def expect_ok
    expect(tracker.ok).to be true
  end

  it "publishes an event with no arguments" do
    sample.on(:a) { ok }
    sample.fire(:a)
    expect_ok
  end

  it "publishes an event with arguments" do
    sample.on(:a) {|arg| ok if arg == "hello"}
    sample.fire(:a, "hello")
    expect_ok
  end

  it "publishes an event where multiple events were defined in the on block" do
    sample.on(:a, :b) { ok }
    sample.fire(:b)
    expect_ok
  end

  it "does nothing if no events have been declared for a fired event" do
    sample.on(:b) { raise }
    sample.fire(:a)
  end

  it "handles multiple event definitions for a single event" do
    sample.on(:a) { ok }
    sample.on(:a) { ok }
    sample.fire(:a)
    expect(tracker.count).to eq 2
  end

  it "publishes an event, ensuring that there are listeners that are going to respond" do
    sample.on(:a) { ok }
    sample.fire!(:a)
    expect_ok
  end

  it "raises if an event published using publish! has no listeners" do
    expect { sample.fire!(:a) }.to raise_error(Publican::NoListenersError, "No listeners are listening for event a")
  end

  describe "#on" do
    it "returns self for method chaining" do
      expect(sample.on(:a) { ok }).to eq(sample)
    end
  end

  describe "#publish" do
    it "returns true when someone was listening" do
      sample.on(:a) { }
      expect(sample.fire(:a)).to be true
    end

    it "returns false when no-one was listening" do
      expect(sample.fire(:a)).to be false
    end
  end
end
