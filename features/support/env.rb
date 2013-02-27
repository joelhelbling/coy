$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 120
end

After do
  close_all_opened_tc_volumes
end

