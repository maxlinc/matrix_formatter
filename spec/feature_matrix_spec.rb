describe MatrixFormatter::FeatureMatrix do
  include JsonSpec::Helpers
  subject(:matrix) { MatrixFormatter::FeatureMatrix.new }

  before do
    matrix.current_product = 'ProductA'
    matrix.current_implementor = 'Implementor1'
  end

  describe '#add_result' do
    it 'associates the result with the current product/feature/implementor' do
      matrix.current_feature = 'Feature X'
      matrix.add_result :passed
      matrix.current_feature = 'Feature Y'
      matrix.add_result :failed
      results = matrix.instance_variable_get('@results')
      results['ProductA']['Feature X']['Implementor1'].should eq(:passed)
      results['ProductA']['Feature Y']['Implementor1'].should eq(:failed)
    end
  end

  describe '#to_json' do
    it 'displays the matrix as json' do
      matrix.current_feature = 'Feature X'
      matrix.add_result :passed
      matrix.current_feature = 'Feature Y'
      matrix.add_result :failed
      expected = generate_normalized_json({
        'ProductA' => {
          'Feature X' => {
            'Implementor1' => :passed
          },
          'Feature Y' => {
            'Implementor1' => :failed
          }
        }
      })
      matrix.to_json.should be_json_eql(expected)
    end
  end
end