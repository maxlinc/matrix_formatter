require "matrix_formatter/version"
require "matrix_formatter/feature_matrix"

# Formatters
require 'matrix_formatter/formatters/base_formatter'

require 'multi_json'
require 'redcarpet'

if defined? RSpec
  RSpec.configure do |c|
    c.add_setting :matrix_implementors, :default => []
    c.add_setting :matrix_options, :default => { :layout => 'default_layout.html.slim' }
  end
end