$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 10
end
