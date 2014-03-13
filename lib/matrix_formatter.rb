require "matrix_formatter/version"
require "matrix_formatter/feature_matrix"

# Formatters
require 'matrix_formatter/formatters/base_formatter'

require 'multi_json'
require 'redcarpet'

RSpec.configure do |c|
  c.add_setting :matrix_implementors, :default => []
end
