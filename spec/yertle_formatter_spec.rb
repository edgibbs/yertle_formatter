require "spec_helper"

describe YertleFormatter do
  let(:output) { StringIO.new }
  let(:notification) { double }
  let(:execution_result) { double }
  let(:example) { double }
  let(:metadata) { { :execution_result => execution_result } }
  let(:formatter) { YertleFormatter.new(output) }

  context "with slow tests" do
    before do
      allow(notification).to receive(:example) { example }
      allow(example).to receive(:metadata) { metadata }
      allow(execution_result).to receive(:run_time) { 0.2 }
    end

    it "displays a turtle emoji" do
      expect(output).to receive(:print).with("\u{1f422}")
      formatter.example_passed(notification)
    end
  end

  context "with a fast test" do
    before do
      allow(notification).to receive(:example) { example }
      allow(example).to receive(:metadata) { metadata }
      allow(execution_result).to receive(:run_time) { 0.01 }
    end

    it "displays the default dot" do
      expect(output).to receive(:print).with(".")
      formatter.example_passed(notification)
    end
  end
end
