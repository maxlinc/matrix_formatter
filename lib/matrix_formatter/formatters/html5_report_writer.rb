class MatrixFormatter::Formatters::HTML5ReportWriter
  SLIM_OPTIONS = {:pretty => true, :format => :html5}
  def initialize output = StringIO.new
    @output = output
  end

  def write_report matrix
    @matrix = matrix
    @output.puts Slim::Template.new(resource_path('dashboard.html.slim'), SLIM_OPTIONS).render(self)
  end

  def merge_results results_dir
    matrix = Hashie::Mash.new
    Dir["#{results_dir}/*.json"].each do |result_file|
      json_results = MultiJson.decode File.read(result_file)
      matrix.results ||= {}
      matrix.results.deep_merge! json_results
    end
    matrix
  end

  def results
    result_stats = {:passed => 0, :failed => 0, :pending => 0, :skipped => 0}
    @matrix.results.inject(result_stats) do |hash, (product_key, product)|
      product.features.each_value do |feature|
        feature.results.each_value do |result|
          hash[result.state.to_sym] += 1;
        end
      end
      hash
    end
    result_stats
  end

  def has_failures?
    results[:failed] != 0
  end

  private

  def labels
    ['Feature Group', 'Feature', @matrix.implementors].flatten
  end

  def sorted_results feature, results
    RSpec.configuration.matrix_implementors.map { |implementor|
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