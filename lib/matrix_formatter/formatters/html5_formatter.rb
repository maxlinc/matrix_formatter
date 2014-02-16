require 'matrix_formatter'
require 'slim'
require 'sprockets'
require 'fileutils'
require 'hashie/mash'

class MatrixFormatter::Formatters::HTML5Formatter < MatrixFormatter::Formatters::BaseFormatter
  SLIM_OPTIONS = {:pretty => true, :format => :html5}
  SPROCKET_OPTIONS = {:minify => false}
  def start_dump
    sprocketify
    @output.puts Slim::Template.new(resource_path('dashboard.html.slim'), SLIM_OPTIONS).render(self)
  end

  def sprocketify
    environment = Sprockets::Environment.new
    environment.append_path resource_path('css')
    environment.append_path resource_path('javascript')
    # FIXME: Not sure Bower integration will work as well as I hoped
    environment.append_path vendor_path('sizzle/dist')
    environment.append_path vendor_path('jquery/dist')
    environment.append_path vendor_path('bootstrap/dist/js')
    environment.append_path vendor_path('bootstrap/dist/css')
    # environment.append_path vendor_path('bootstrap/dist/fonts')

    if SPROCKET_OPTIONS[:minify]
      environment.js_compressor  = :uglify
      environment.css_compressor = :scss
    end
    environment['dashboard.js'].write_to 'docs/resources/dashboard.js'
    environment['dashboard.css'].write_to 'docs/resources/dashboard.css'

    # Copy bootstrap fonts and icons
    FileUtils.mkdir_p "docs/fonts/"
    FileUtils.cp_r vendor_path('bootstrap/dist/fonts/'), "docs/"
  end

  private

  def labels
    ['Feature Group', 'Feature', @matrix.implementors].flatten
  end

  def sorted_results feature, results
    @matrix.implementors.map { |implementor|
      results[implementor] || Hashie::Mash.new({
        :state => "unknown",
        "data" => {"data-challenge"=>feature.data["challenge"], "data-sdk"=>implementor}
      })
    }
  end

  def resource_path name
    File.join(File.dirname(File.expand_path(__FILE__)), '../../../resources/html5', name)
  end

  def vendor_path name
    File.join(File.dirname(File.expand_path(__FILE__)), '../../../resources/vendor', name)
  end

  def partial name
    partial_file = "_#{name}.html.slim"
    Slim::Template.new(resource_path(partial_file), SLIM_OPTIONS).render(self)
  end
end
