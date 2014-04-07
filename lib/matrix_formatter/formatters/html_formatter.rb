require 'matrix_formatter'
require 'matrix_formatter/formatters/markdown_formatter'

class MatrixFormatter::Formatters::HTMLFormatter < RSpec::Core::Formatters::BaseFormatter
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
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)

    @output.puts header
    @output.puts renderer.render(markdown)
    @output.puts footer
  end

  def header
    """
    <html>
    <head>
    <style type=\"text/css\">
      td {
          padding: 7px 10px;
          vertical-align: top;
          text-align: left;
          border: 1px solid #ddd;
      }
      .passed {
        color: green;
      }
      .failed {
        color: red;
      }
      .pending {
        color: blue;
      }
    </style>
    </head>
    <body>
    """
  end

  def footer
    """
    </body>
    <script type=\"text/javascript\">
      var table = document.getElementsByTagName('table')[0];
      var tbody = table.getElementsByTagName('tbody')[0];
      var cells = tbody.getElementsByTagName('td');

      for (var i=0, len=cells.length; i<len; i++){
          if (cells[i].innerText === 'failed'){
              cells[i].className = 'failed';
          }
          else if (cells[i].innerText === 'passed'){
              cells[i].className = 'passed';
          }
          else if (cells[i].innerText === 'pending'){
              cells[i].className = 'pending';
          }
      }
    </script>
    </html>
    """
  end
end
