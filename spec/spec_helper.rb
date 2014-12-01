require "coveralls"

Coveralls.wear!

Dir[File.join(".", "lib", "**/*.rb")].each do |file|
  require file
end

RSpec.configure do |configuration|
  configuration.add_setting :yertle_slow_time
  configuration.yertle_slow_time = 0.1
end
