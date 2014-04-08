require 'matrix_formatter'
require "matrix_formatter/formatters/html5_report_writer"

class MatrixFormatter::Formatters::AngularFormatter < RSpec::Core::Formatters::BaseFormatter
  include MatrixFormatter::Formatters::BaseFormatter

  def initialize(output)
    super(output)
    @matrix = matrix
    @options = RSpec.configuration.matrix_options
  end

  def start_dump
    @options[:view] = 'angular.html.slim'
    # @options[:layout] = nil
    report_writer = MatrixFormatter::Formatters::HTML5ReportWriter.new(@output, @options)
    report_writer.parse_results @matrix.to_json
    report_writer.write_report
  end
end
