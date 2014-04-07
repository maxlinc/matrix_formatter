require 'matrix_formatter'

class MatrixFormatter::Formatters::JSONFormatter < RSpec::Core::Formatters::BaseFormatter
  include MatrixFormatter::Formatters::BaseFormatter

  def initialize(output)
    super(output)
    @matrix = matrix
  end

  def start_dump
    @output.puts @matrix.to_json
  end
end
