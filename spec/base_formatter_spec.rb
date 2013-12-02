require 'spec_helper'
require 'stringio'

describe MatrixFormatter::Formatters::BaseFormatter do
  let(:output) { StringIO.new }

  let(:matrix) { instance_double("MatrixFormatter::FeatureMatrix") }

  let(:implementors) { ['legacy', 'nextgen', 'mobile'] }
  let(:formatter) do
    formatter = MatrixFormatter::Formatters::BaseFormatter.new(output)
    formatter.matrix = matrix
    formatter.start(2)
    formatter
  end

  let(:example_group) { class_double('RSpec::Core::ExampleGroup') }
  let(:example) { instance_double('RSpec::Core::Example') }

  describe '#example_group_started' do
    context 'starting an implementor' do
      it 'sets the current feature to the example description' do
        matrix.should_receive(:implementors).and_return implementors
        implementor = implementors.sample
        example_group.should_receive(:description).and_return implementor
        matrix.should_receive(:current_implementor=).with(implementor)
        formatter.example_group_started example_group
      end
    end

    it 'sets the current product to the example description' do
      description = 'some cool product'
      matrix.should_receive(:implementors).and_return implementors
      example_group.should_receive(:description).and_return description
      matrix.should_receive(:current_product=).with(description)
      formatter.example_group_started example_group
    end
  end

  describe '#example_started' do
    it 'sets the current feature to the example description' do
      description = 'some cool feature'
      example.should_receive(:description).and_return description
      matrix.should_receive(:current_feature=).with(description)
      formatter.example_started example
    end
  end

  [:passed, :failed, :pending].each do |status|
    method = "example_#{status.to_s}"
    describe "##{method}" do
      it 'tells the FeatureMatrix that about the result' do
        matrix.should_receive(:add_result).with(status)
        formatter.send(method.to_sym, example)
      end
    end
  end
end