require 'matrix_formatter'
require "matrix_formatter/assets/generator"
require "matrix_formatter/formatters/html5_report_writer"
require 'slim'
require 'sprockets'
require 'fileutils'
require 'hashie/mash'

class MatrixFormatter::Formatters::HTML5Formatter < MatrixFormatter::Formatters::BaseFormatter
  def start_dump
    asset_generator = MatrixFormatter::Assets::Generator.new
    asset_generator.generate
    report_writer = HTMLReportWriter.new('docs', @output)
    report_writer.writer_report
  end
end
