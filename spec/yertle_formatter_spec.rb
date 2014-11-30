require "spec_helper"

describe YertleFormatter do
  let(:output) { StringIO.new }
  let(:formatter) { YertleFormatter.new(output) }
  let(:notification) { instance_double("RSpec::Core::Notifications::ExampleNotification") }
  let(:execution_result) { RSpec::Core::Example::ExecutionResult.new }
  let(:example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "description", {}) }

  describe "#example_passed" do
    before do
      allow(example).to receive(:metadata) { { execution_result: execution_result } }
      allow(notification).to receive(:example) { example }
    end

    context "with a slow test" do
      it "displays a turtle emoji" do
        execution_result.send(:run_time=, 0.2)
        formatter.example_passed(notification)
        expect(output.string).to eq("\u{1f422} ")
      end
    end

    context "with a fast test" do
      it "displays the default dot" do
        execution_result.send(:run_time=, 0.01)
        expect(output).to receive(:print).with(".")
        formatter.example_passed(notification)
      end
    end
  end

  describe "#dump_summary" do
    let(:fast_example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "description", {}) }
    let(:fast_execution_result) { RSpec::Core::Example::ExecutionResult.new }
    let(:fast_metadata) { { execution_result: fast_execution_result } }
    let(:slow_example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "description", {}) }
    let(:slow_execution_result) { RSpec::Core::Example::ExecutionResult.new }
    let(:slow_metadata) { { execution_result: slow_execution_result } }
    let(:summary_notification) do
      notification = RSpec::Core::Notifications::SummaryNotification.new
      notification.examples = [fast_example, slow_example]
      notification.duration = 9
      notification.load_time = 5
      notification.failed_examples = []
      notification.pending_examples = []
      notification
    end

    context "with slow tests" do
      let(:final_output) do
        <<-FINAL_OUTPUT

Finished in 9 seconds (files took 5 seconds to load)
2 examples, 0 failures

------
0.2
        FINAL_OUTPUT
      end

      before do
        allow(fast_example).to receive(:metadata) { fast_metadata }
        fast_execution_result.send(:run_time=, 0.01)
        allow(slow_example).to receive(:metadata) { slow_metadata }
        slow_execution_result.send(:run_time=, 0.2)
      end

      it "displays a list of the slow tests after the default summary" do
        formatter.dump_summary(summary_notification)
        expect(output.string).to eq(final_output)
      end
    end

    context "with no slow tests" do
      let(:final_output) do
        <<-FINAL_OUTPUT

Finished in 9 seconds (files took 5 seconds to load)
2 examples, 0 failures

------
        FINAL_OUTPUT
      end

      before do
        summary_notification.examples = [fast_example, fast_example]
        allow(fast_example).to receive(:metadata) { fast_metadata }
        fast_execution_result.send(:run_time=, 0.01)
      end

      it "displays just the default summary and a seperator" do
        formatter.dump_summary(summary_notification)
        expect(output.string).to eq(final_output)
      end
    end
  end
end
