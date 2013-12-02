require 'matrix_formatter'

implementors = ['LegacyWidget', 'HTML5Widget']
RSpec.configure do |config|
  config.matrix_implementors = ['LegacyWidget', 'HTML5Widget']
end

describe 'MVP Features' do
  implementors.each do |implementor|
    context implementor do
      it 'creates a thing' do
        fail if implementor.eql? implementors.first
      end
      it 'saves a thing' do
        fail unless implementor.eql? implementors.first
      end
    end
  end
end

describe 'Cool Features' do
  implementors.each do |implementor|
    context implementor do
      it 'renders a nyan cat video' do
        fail if implementor.eql? implementors.first
      end
      it 'does a headstand' do
        fail unless implementor.eql? implementors.first
      end
      pending 'reads your mind'
    end
  end
end

