require 'matrix_formatter'
require 'nokogiri'

class MatrixFormatter::Formatters::HTML5Formatter < MatrixFormatter::Formatters::MarkdownFormatter
  def start_dump
    @renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)

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
          @matrix.results.each do |product_key, product|
            inserted_group_td = false
            product.features.each do |feature_key, feature|
              results = feature.results
              doc.tr {
                unless inserted_group_td
                  doc.td(:class => "feature_group", :rowspan => product.features.size) {
                    doc.text product_key
                    if product.markdown
                      doc.aside {
                        doc << @renderer.render(product.markdown)
                      }
                    end
                  }
                  inserted_group_td = true
                end
                doc.td(:class => "feature") {
                  doc.text feature_key
                  if feature.markdown
                    doc.aside {
                      doc << @renderer.render(feature.markdown)
                    }
                  end
                }
                sorted_results = RSpec.configuration.matrix_implementors.map { |implementor|
                  results[implementor]
                }
                sorted_results.each do |result|
                  doc.td(result.data.merge({:class => result.state})) {
                    if result.link
                      doc.a(:href => result.link, :target => "_blank") {
                        doc.text result.state
                      }
                    else
                      doc.text result.state
                    end

                    if result.markdown
                      doc.aside {
                        doc << @renderer.render(result.markdown)
                      }
                    end
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
