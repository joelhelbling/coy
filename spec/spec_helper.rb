require 'fakefs/spec_helpers'
require File.join(File.dirname(__FILE__), 'io_helpers')

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))

RSpec.configure do |cfg|
  cfg.treat_symbols_as_metadata_keys_with_true_values = true
  cfg.include FakeFS::SpecHelpers, fakefs: true
  cfg.include IOHelpers, capture_io: true
end
