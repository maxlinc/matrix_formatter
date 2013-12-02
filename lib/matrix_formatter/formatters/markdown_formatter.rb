require 'matrix_formatter'

class MatrixFormatter::Formatters::MarkdownFormatter < MatrixFormatter::Formatters::BaseFormatter
  def markdown
    buffer = StringIO.new
    header_line = ['Feature Group', 'Feature', RSpec.configuration.matrix_implementors].join ' | '
    buffer.puts header_line
    buffer.puts header_line.gsub(/[^|]/, '-')

    @matrix.results.each do |product, features|
      # Only show the product on the first line
      product_text = "**#{product}**"
      features.each do |feature_key, feature_results|
        states = RSpec.configuration.matrix_implementors.map { |implementor|
          feature_results[implementor]
        }
        buffer.puts [product_text, "**#{feature_key}**", states].join ' | '
        product_text = ''
      end
    end
    buffer.string
  end

  def start_dump
    @output.puts markdown
  end
end
