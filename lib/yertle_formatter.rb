require "rspec/core/formatters/base_text_formatter"

class YertleFormatter < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :example_passed, :dump_summary

  attr_reader :slow_specs

  def example_passed(notification)
    if slow_spec?(notification.example)
      @slow_specs = true
      print_turtle
    else
      print_dot
    end
  end

  def dump_summary(summary_notification)
    super(summary_notification)
    summarize_slow_specs(summary_notification) if slow_specs
  end

  private

  def slow_spec?(example)
    example.metadata[:execution_result].run_time > threshold
  end

  def print_turtle
    output.print "\u{1f422} "
  end

  def print_dot
    output.print "."
  end

  def threshold
    slow_time_environment_variable || RSpec.configuration.yertle_slow_time || 0.1
  end

  def slow_time_environment_variable
    ENV["YERTLE_SLOW_TIME"] ? ENV["YERTLE_SLOW_TIME"].to_f : nil
  end

  def summarize_slow_specs(summary_notification)
    output.puts "\n------"
    slow_spec_examples(summary_notification).each do |example|
      slow_test_description = <<-SLOW_TEST_OUTPUT
"#{example.full_description}" #{example.metadata[:execution_result].run_time} seconds
#{example.location}
      SLOW_TEST_OUTPUT
      output.puts slow_test_description
    end
  end

  def slow_spec_examples(summary_notification)
    summary_notification.examples.select do |example|
      slow_spec?(example)
    end.sort do |example_1, example_2|
      example_2.metadata[:execution_result].run_time <=> example_1.metadata[:execution_result].run_time
    end
  end
end
