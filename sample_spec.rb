require 'matrix_formatter'

implementors = ['LegacyWidget', 'HTML5Widget']
RSpec.configure do |config|
  config.matrix_implementors = ['LegacyWidget', 'HTML5Widget']
end

describe 'Cool Feature Group' do
  implementors.each do |implementor|
    describe implementor do
      it 'makes cool stuff' do
        fail if implementor.eql? implementors.first
      end
      pending 'reads your mind'
    end
  end
end