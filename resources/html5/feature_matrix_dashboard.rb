require 'spec_helper'
require 'matrix_formatter'
require 'nokogiri'
require 'hashie/mash'

module Formatter
  class FeatureMatrixDashboard
    attr_reader :matrix

    def initialize results_dir, output = nil
      @output = output || StringIO.new
      @results_dir = results_dir
      @matrix = Hashie::Mash.new
    end

    def merge_results
      Dir["#{@results_dir}/*.json"].each do |result_file|
        results = MultiJson.decode File.read(result_file)
        @matrix.deep_merge! results
      end
    end

    def results
      results = {:passed => 0, :failed => 0, :pending => 0, :skipped => 0}
      @matrix.inject(results) do |hash, (_, product)|
        product.features.each_value do |feature|
          feature.results.each_value do |result|
            hash[result.state.to_sym] += 1;
          end
        end
        hash
      end
      results
    end

    def has_failures?
      results[:failed] != 0
    end

    def html5_matrix
      @renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)

      @output.puts header
      @output.puts matrix_html
      @output.puts footer
      @output.string
    end

    protected

    def matrix_html
      @builder = Nokogiri::HTML::Builder.new do |doc|
        doc.table(:id => "feature_matrix", :class => "feature_matrix table") {
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
            @matrix.each do |product_key, product|
              inserted_group_td = false
              product.features.each do |feature_key, feature|
                results = feature.results # bad key name
                doc.tr {
                  unless inserted_group_td
                    doc.td(:class => "feature_group", 'data-feature-group' => product_key, :rowspan => product.features.size) {
                      doc.span(:class => "section_label") {
                        doc.text product_key
                      }
                      doc.span(:class => 'btn-group pull-right') {
                        doc.button(:type => 'button', :class => 'btn btn-xs dropdown-toggle', 'data-toggle' => 'dropdown') {
                          doc.i(:class => "glyphicon glyphicon-chevron-down")
                        }
                        doc.ul(:class => "dropdown-menu", :role => "menu") {
                          if product.markdown
                            doc.li {
                              markdown_aside doc, product.markdown, 'Product Overview'
                            }
                          end
                        }
                      }
                    }
                    inserted_group_td = true
                  end
                  doc.td(:class => "feature", 'data-feature' => feature_key) {
                    doc.span(:class => "section_label" ) {
                      doc.text feature_key
                    }
                    doc.span(:class => 'btn-group pull-right') {
                      doc.button(:type => 'button', :class => 'btn btn-xs dropdown-toggle', 'data-toggle' => 'dropdown') {
                        doc.i(:class => "glyphicon glyphicon-chevron-down")
                      }
                      doc.ul(:class => "dropdown-menu", :role => "menu") {
                        if feature.markdown
                          doc.li {
                            markdown_aside doc, feature.markdown, 'Scenario'
                          }
                        end
                        if feature.environment
                          doc.li {
                            environment_table doc, feature.environment, 'Environment'
                          }
                        end
                        if feature.services
                          doc.li {
                            services_list doc, feature.services, 'Services'
                          } 
                        end
                      }
                    }
                  }
                  sorted_results = RSpec.configuration.matrix_implementors.map { |implementor|
                    results[implementor] || Hashie::Mash.new({
                      :state => 'unknown',
                      "data" => {"data-challenge"=>feature['data-challenge'], "data-sdk"=>implementor}
                    })
                  }
                  sorted_results.each do |result|
                    doc.td({:class => result.state}.merge(result.data)) {
                      doc.a({"data-toggle" => "modal", "data-feature-group" => product_key, "data-feature" => feature_key, :href => "#code_modal"}.merge(result.data)) {
                        doc.span {
                          doc.text result.state
                        }
                        if result.state == 'passed'
                          doc.span(:class => 'badge pull-right') {
                            doc.text "#{result.runtime.round}s"
                          }
                        end
                      }

                      if result.markdown # results should probably prefer docco over markdown metadata
                        markdown_aside doc, result.markdown
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

    def header
      <<-EOS
      <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <title>Feature Matrix - jsFiddle demo by devopsy</title>
        <script type='text/javascript' src='//code.jquery.com/jquery-2.0.3.min.js'></script>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
        <!-- Optional theme -->
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
        <!-- Latest compiled and minified JavaScript -->
        <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="resources/dashboard.css"></link>
        <script type='text/javascript' src="resources/jquery.stickytableheaders.min.js"></script>
        <script type='text/javascript' src="http://cdnjs.cloudflare.com/ajax/libs/ace/1.1.01/ace.js"></script>
      </head>
      EOS
    end

    def footer
      <<-EOS
      <div class="modal fade" id="modalPlaceHolder">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&#xD7;</button>
              <h4 class="modal-title">Modal title</h4>
            </div>
            <div class="modal-body">
              <p>This is a test</p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
          </div>
          <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
      </div>
      <!-- /.modal -->
      <div class="modal bigmodal fade" id="code_modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
              <h4 class="modal-title">Modal title</h4>
            </div>
            <div class="modal-body container">
              <!-- Header and Nav -->
              <div class="row">
                <div class="col-lg-3">
                  <h1></h1>
                </div>
                <div class="col-lg-8">
                  <div>
                    <ul id="sdk-nav" class="nav nav-pills"></ul>
                  </div>
                </div>
                <div class="col-lg-1 right">
                  <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">Source <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                      <li><a href="#">Source</a>
                      </li>
                      <li id="annotated-nav"><a class="disabled" href="#">Annotated</a>
                      </li>
                      <li id="github-nav"></li>
                    </ul>
                  </div>
                </div>
              </div>
              <!-- End Header and Nav -->
              <div class="row">
                <!-- Main Content Section -->
                <!-- This has been source ordered to come first in the markup (and on small devices) but to be to the right of the nav on larger screens -->
                <div class="col-lg-9 col-lg-push-3">
                  <div id="editor-mask" class="row">
                    <div id="editor-container">
                      <div id="editor"></div>
                    </div>
                  </div>
                </div>
                <!-- Nav Sidebar -->
                <!-- This is source ordered to be pulled to the left on larger screens -->
                <div class="col-lg-3 col-lg-pull-9 ">
                  <div class="panel-group" id="accordion">
                  </div>
                </div>
              </div>
              <!-- Footer -->
              <footer class="row">
                <!-- Nothing yet -->
              </footer>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              <button id="test_changes" type="button" class="btn btn-primary" data-container="body" data-toggle="popover" data-placement="top" data-content="Coming soon?">Test changes</button>
            </div>
          </div>
        </div>
      </div>
      </body>
      <script type="text/javascript" src="resources/dashboard.js"></script>
      </html>
      EOS
    end

    def markdown_aside doc, markdown, label
      doc.a(:class => "modal-button") {
        doc.text label
      }
      doc.aside("data-label" => label) {
        doc << @renderer.render(markdown)
      }
    end

    def environment_table doc, environment, label
      doc.a(:class => "modal-button") {
        doc.text label
      }
      doc.aside("data-label" => label) {
        doc.table(:class => "table table-striped") {
          doc.thead {
            doc.tr {
              doc.th {
                doc.text "Environment Variable"
              }
              doc.th {
                doc.text "Value"
              }
            }
          }
          doc.tbody {
            environment.each do | key, value |
              doc.tr {
                doc.td {
                  doc.text key
                }
                doc.td {
                  doc.text value
                }
              }
            end
          }
        }
      }
    end

    def services_list doc, services, label
      doc.a(:class => "modal-button") {
        doc.text label
      }
      doc.aside("data-label" => label) {
        doc.ul {
          services.each do |service|
            doc.li {
              doc.text service
            }
          end
        }
      }
    end
  end
end