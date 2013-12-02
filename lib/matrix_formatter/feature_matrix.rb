module MatrixFormatter
  class FeatureMatrix
    attr_accessor :current_feature, :current_implementor, :current_product
    attr_reader :implementors
    attr_reader :results

    def initialize
      @implementors = RSpec.configuration.matrix_implementors
      # results[product][feature][implementor]
      @results = Hash.new { |product_hash, product_key|
        product_hash[product_key] = Hash.new { |feature_hash, feature_key|
          feature_hash[feature_key] = Hash.new { |implementor_hash, implementor_key|
            implementor_hash[implementor_key] = Hash.new
          }
        }
      }
    end

    def add_result state
      @results[current_product][current_feature][current_implementor] = state
    end

    def to_json
      MultiJson.encode @results
    end
  end
end