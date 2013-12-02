require 'matrix_formatter'

class MatrixFormatter::Formatters::TextFormatter < MatrixFormatter::Formatters::BaseFormatter
  def start_dump
    @output.puts @matrix.to_json
  end
end
