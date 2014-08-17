require "coveralls"

Coveralls.wear!

Dir[File.join(".", "lib", "**/*.rb")].each do |file|
  require file
end
