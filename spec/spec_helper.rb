require 'matrix_formatter'
require 'rspec/fire'
require 'json_spec'

RSpec.configure do |config|
  config.include(RSpec::Fire)
  # Unfortunely rspec-fire doesn't support expect, use should
  # until it's fixed and merged into rspec 3.
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
  config.mock_with :rspec do |c|
    c.syntax = :should
  end
end

RSpec::Fire.configure do |config|
  config.verify_constant_names = true
end
