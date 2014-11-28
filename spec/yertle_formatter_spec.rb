require "spec_helper"

describe YertleFormatter do
  let(:output) { StringIO.new }
  let(:notification) { instance_double("RSpec::Core::Notifications::ExampleNotification") }
  let(:execution_result) { instance_double("RSpec::Core::Example::ExecutionResult") }
  let(:example) { instance_double("RSpec::Core::Example") }
  let(:metadata) { { execution_result: execution_result } }
  let(:formatter) { YertleFormatter.new(output) }

  describe "#example_passed" do
    context "with a slow test" do
      before do
        allow(notification).to receive(:example) { example }
        allow(example).to receive(:metadata) { metadata }
        allow(execution_result).to receive(:run_time) { 0.2 }
      end

      it "displays a turtle emoji" do
        expect(output).to receive(:print).with("\u{1f422} ")
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

  describe "#dump_summary" do
    let(:fast_example) { instance_double("RSpec::Core::Example") }
    let(:fast_execution_result) { instance_double("RSpec::Core::Example::ExecutionResult") }
    let(:fast_metadata) { { execution_result: fast_execution_result } }
    let(:slow_example) { instance_double("RSpec::Core::Example") }
    let(:slow_execution_result) { instance_double("RSpec::Core::Example::ExecutionResult") }
    let(:slow_metadata) { { execution_result: slow_execution_result } }
    let(:summary_notification) { instance_double("RSpec::Core::Notifications::SummaryNotification") }
    let(:default_summary) { "fully formatted" }

    context "with slow tests" do
      before do
        allow(summary_notification).to receive(:fully_formatted) { default_summary }
        allow(output).to receive(:puts).with(default_summary)
        allow(summary_notification).to receive(:examples) { [fast_example, slow_example] }
        allow(fast_example).to receive(:metadata) { fast_metadata }
        allow(fast_execution_result).to receive(:run_time) { 0.01 }
        allow(slow_example).to receive(:metadata) { slow_metadata }
        allow(slow_execution_result).to receive(:run_time) { 0.2 }
      end

      it "displays a list of the slow tests after the default summary" do
        expect(output).to receive(:puts).with(default_summary)
        expect(output).to receive(:puts).with("\n------")
        expect(output).to receive(:puts).with(0.2)
        formatter.dump_summary(summary_notification)
      end
    end
  end
end
