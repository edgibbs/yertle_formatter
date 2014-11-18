require "rspec/core/formatters/base_text_formatter"

class YertleFormatter < RSpec::Core::Formatters::BaseTextFormatter
  THRESHOLD = 0.1

  RSpec::Core::Formatters.register self, :start, :example_passed

  def example_passed(notification)
    if notification.example.metadata[:execution_result].run_time > THRESHOLD
      output.print "\u{1f422} "
    else
      output.print "."
    end
  end
end
