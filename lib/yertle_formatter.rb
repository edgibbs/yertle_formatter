require "rspec/core/formatters/base_text_formatter"

class YertleFormatter < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :example_passed, :dump_summary

  def example_passed(notification)
    if slow_spec?(notification.example)
      print_turtle
    else
      print_dot
    end
  end

  def dump_summary(summary_notification)
    super(summary_notification)
    output.puts "\n------"
    summary_notification.examples.each do |example|
      output.puts example.metadata[:execution_result].run_time if slow_spec?(example)
    end
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
    if RSpec.configuration.yertle_slow_time
      RSpec.configuration.yertle_slow_time
    else
      0.1
    end
  end
end
