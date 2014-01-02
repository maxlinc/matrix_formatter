require 'matrix_formatter'
require 'nokogiri'

class MatrixFormatter::Formatters::HTML5Formatter < MatrixFormatter::Formatters::MarkdownFormatter
  def start_dump
    @output.puts header
    @output.puts matrix_html
    @output.puts footer
  end

  protected

  def matrix_html
    @builder = Nokogiri::HTML::Builder.new do |doc|
      doc.table {
        doc.thead(:class => "matrix_labels") {
          doc.tr {
            labels = ['Feature Group', 'Feature', RSpec.configuration.matrix_implementors].flatten
            labels.each do | label_text |
              doc.th {
                doc.text label_text
              }
            end
          }
        }
        doc.tbody(:class => "feature_matrix") {
          @matrix.results.each do |product, features|
            inserted_group_td = false
            features.each do |feature_key, feature_results|
              doc.tr {
                unless inserted_group_td
                  doc.td(:class => "feature_group", :rowspan => features.size) {
                    doc.text product
                  }
                  inserted_group_td = true
                end
                doc.td(:class => "feature") {
                  doc.text feature_key
                  doc.aside {
                    doc.text "A test"
                  }
                }
                states = RSpec.configuration.matrix_implementors.map { |implementor|
                  feature_results[implementor]
                }
                states.each do |state|
                  doc.td(:class => state) {
                    doc.text state
                  }
                end
              }
            end
          end
        }
      }
    end
    @builder.doc.inner_html
  end

  def load_resource name
    file = File.join(File.dirname(File.expand_path(__FILE__)), '../../../resources', name)
    File.read file
  end

  def css
    load_resource "html5.css"
  end

  def javascript
    load_resource "html5.js"
  end

  def header
    """
    <html>
    <head>
    <script type='text/javascript' src='https://code.jquery.com/jquery-2.0.2.js'></script>
    <style type=\"text/css\">
      #{css}
    </style>
    </head>
    <body>
    """
  end

  def footer
    """
    </body>
    <script type=\"text/javascript\">
      #{javascript}
    </script>
    </html>
    """
  end
end
