require "spec_helper"

shared_examples "a slow test" do |run_time|
  it "displays a turtle emoji" do
    execution_result.send(:run_time=, run_time)
    formatter.example_passed(notification)
    expect(output.string).to eq("\u{1f422} ")
  end

  it "sets slow specs flag to true" do
    execution_result.send(:run_time=, run_time)
    formatter.example_passed(notification)
    expect(formatter.slow_specs).to be true
  end
end

shared_examples "a fast test" do |run_time|
  it "displays the default dot" do
    execution_result.send(:run_time=, run_time)
    expect(output).to receive(:print).with(".")
    formatter.example_passed(notification)
  end

  it "leaves slow specs flag as false" do
    execution_result.send(:run_time=, run_time)
    formatter.example_passed(notification)
    expect(formatter.slow_specs).to be_falsey
  end
end

describe YertleFormatter do
  let(:output) { StringIO.new }
  let(:formatter) { YertleFormatter.new(output) }
  let(:notification) { instance_double("RSpec::Core::Notifications::ExampleNotification") }
  let(:execution_result) { RSpec::Core::Example::ExecutionResult.new }
  let(:example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "description", {}) }

  before do
    RSpec.configuration.yertle_slow_time = nil
    ENV.delete("YERTLE_SLOW_TIME")
  end

  describe "#example_passed" do
    before do
      allow(example).to receive(:metadata) { { execution_result: execution_result } }
      allow(notification).to receive(:example) { example }
    end

    context "with YERTLE_SLOW_TIME configured" do
      before do
        ENV["YERTLE_SLOW_TIME"] = "0.4"
      end

      it_behaves_like "a slow test", 0.5

      it_behaves_like "a fast test", 0.3
    end

    context "with yertle_slow_time configured" do
      before do
        RSpec.configuration.yertle_slow_time = 0.2
      end

      it_behaves_like "a slow test", 0.3

      it_behaves_like "a fast test", 0.1
    end

    context "with YERTLE_SLOW_TIME and yertle_slow_time configured" do
      before do
        ENV["YERTLE_SLOW_TIME"] = "0.4"
        RSpec.configuration.yertle_slow_time = 0.1
      end

      context "uses the environment variable setting" do
        it_behaves_like "a slow test", 0.5

        it_behaves_like "a fast test", 0.3
      end
    end

    context "with no yertle_slow_time or YERTLE_SLOW_TIME configured" do
      it_behaves_like "a slow test", 0.2

      it_behaves_like "a fast test", 0.01
    end
  end

  describe "#dump_summary" do
    let(:fast_example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "Fast Test Description", {}) }
    let(:fast_execution_result) { RSpec::Core::Example::ExecutionResult.new }
    let(:fast_metadata) { { execution_result: fast_execution_result } }
    let(:slow_example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "Slow Test Description", {}) }
    let(:slow_execution_result) { RSpec::Core::Example::ExecutionResult.new }
    let(:slow_metadata) { { execution_result: slow_execution_result } }
    let(:slower_example) { RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, "Slower Test Description", {}) }
    let(:slower_execution_result) { RSpec::Core::Example::ExecutionResult.new }
    let(:slower_metadata) { { execution_result: slower_execution_result } }
    let(:summary_notification) do
      notification = RSpec::Core::Notifications::SummaryNotification.new
      notification.examples = [fast_example, slow_example, slower_example]
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
3 examples, 0 failures

------
" Slower Test Description" 0.3 seconds
./spec/yertle_formatter_spec.rb:96
" Slow Test Description" 0.2 seconds
./spec/yertle_formatter_spec.rb:93
        FINAL_OUTPUT
      end

      before do
        formatter.instance_variable_set(:@slow_specs, true)
        allow(fast_example).to receive(:metadata) { fast_metadata }
        fast_execution_result.send(:run_time=, 0.01)
        allow(slow_example).to receive(:metadata) { slow_metadata }
        slow_execution_result.send(:run_time=, 0.2)
        allow(slower_example).to receive(:metadata) { slower_metadata }
        slower_execution_result.send(:run_time=, 0.3)
      end

      it "displays a sorted list of the slow tests after the default summary" do
        formatter.dump_summary(summary_notification)
        expect(output.string).to eq(final_output)
      end
    end

    context "with no slow tests" do
      let(:final_output) do
        <<-FINAL_OUTPUT

Finished in 9 seconds (files took 5 seconds to load)
2 examples, 0 failures
        FINAL_OUTPUT
      end

      before do
        summary_notification.examples = [fast_example, fast_example]
        allow(fast_example).to receive(:metadata) { fast_metadata }
        fast_execution_result.send(:run_time=, 0.01)
      end

      it "displays just the default summary and a separator" do
        formatter.dump_summary(summary_notification)
        expect(output.string).to eq(final_output)
      end
    end
  end
end
