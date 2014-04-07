require 'matrix_formatter'
class MatrixFormatter::Formatters::MarkdownFormatter < RSpec::Core::Formatters::BaseFormatter
  include MatrixFormatter::Formatters::BaseFormatter

  def initialize(output)
    super(output)
    @matrix = matrix
  end

  def markdown
    buffer = StringIO.new
    header_line = ['Feature Group', 'Feature', RSpec.configuration.matrix_implementors].join ' | '
    buffer.puts header_line
    buffer.puts header_line.gsub(/[^|]/, '-')

    @matrix.results.each do |product_name, product|
      # Only show the product on the first line
      product_text = "**#{product_name}**"
      product.features.each do |feature_key, features|
        states = RSpec.configuration.matrix_implementors.map { |implementor|
          begin
            features.results[implementor]["state"]
          rescue NoMethodError => e
            "skipped" # This should only happen when running a subset of tests
          end
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
