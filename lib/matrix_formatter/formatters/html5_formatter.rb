require 'matrix_formatter'
require "matrix_formatter/formatters/html5_report_writer"

class MatrixFormatter::Formatters::HTML5Formatter < MatrixFormatter::Formatters::BaseFormatter
  def start_dump
    report_writer = MatrixFormatter::Formatters::HTML5ReportWriter.new(@output)
    report_writer.parse_results @matrix.to_json
    report_writer.write_report
  end
end
