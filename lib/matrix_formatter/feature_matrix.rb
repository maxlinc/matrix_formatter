require 'hashie/dash'
require 'hashie/extensions/deep_merge'

module MatrixFormatter
  class MatrixItem < Hashie::Dash
    property :data
    property :link
    property :markdown
    property :services
    property :environment

    def initialize example
      self.data = example.metadata.select {|k,v| k.to_s.start_with? 'data-'}
      self.environment = example.metadata[:environment]
      self.services = example.metadata[:services]
      markdown = example.metadata[:markdown]
      if example.is_a? RSpec::Core::Example
        parent_markdown = example.example_group.parent_groups.map {|eg| eg.metadata[:markdown]}
      else
        parent_markdown = example.parent_groups.reject{|eg| eg != self}.map {|eg| eg.metadata[:markdown]}
      end
      self.markdown = markdown unless parent_markdown.include?(markdown)
    end
  end

  class MatrixProduct < MatrixItem
    property :features
    def initialize example_group
      super
      self.features = {}
    end
  end

  class MatrixFeature < MatrixItem
    property :results
    def initialize example_group
      super
      self.results = {}
    end
  end

  class MatrixResult < MatrixItem
    property :state, :required => true
    def initialize state, example
      super(example)
      self.state = state
    end
  end

  class FeatureMatrix
    attr_reader :implementors
    attr_reader :results

    class Results < Hash
      include Hashie::Extensions::DeepMerge
      def initialize
        super { |product_hash, product_key|
          product = MatrixItem.new product_key
          product_hash[product] = Hash.new { |feature_hash, feature_key|
            feature = MatrixItem.new feature_key
            feature_hash[feature] = Hash.new { |implementor_hash, implementor_key|
              implementor_hash[implementor_key] = Hash.new
            }
          }
        }
      end
    end

    def initialize
      @implementors = RSpec.configuration.matrix_implementors
      @results = Results.new
    end

    def add_product example_group
      product = MatrixProduct.new example_group
      @results[example_group.display_name] = product
    end

    def add_feature example_group
      feature = MatrixFeature.new example_group
      @results[example_group.top_level_description].features[example_group.display_name] = feature
    end

    def add_implementation_result state, example
      result = MatrixResult.new state, example
      feature = example.example_group
      product = feature.top_level_description
      @results[product].features[feature.display_name].results[example.description] = result
    end

    def to_json(options={})
      MultiJson.encode @results, :pretty => true
    end
  end
end