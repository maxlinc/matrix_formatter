require 'matrix_formatter'
require 'slim'
require 'sprockets'
require 'fileutils'
require 'hashie/mash'

class MatrixFormatter::Formatters::HTML5Formatter < MatrixFormatter::Formatters::BaseFormatter
  SLIM_OPTIONS = {:pretty => true, :format => :html5}
  def start_dump
    asset_generator = MatrixFormatter::Assets::Generator.new
    asset_generator.generate
    @output.puts Slim::Template.new(resource_path('dashboard.html.slim'), SLIM_OPTIONS).render(self)
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
