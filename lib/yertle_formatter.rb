require "rspec/core/formatters/base_text_formatter"

class YertleFormatter < RSpec::Core::Formatters::BaseTextFormatter

  RSpec::Core::Formatters.register self, :start

  def start(notification)
    puts "in start"
  end
end
