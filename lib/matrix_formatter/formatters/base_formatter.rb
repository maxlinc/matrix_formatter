require 'rspec/core/formatters/base_text_formatter'

module MatrixFormatter
  module Formatters
    class BaseFormatter < RSpec::Core::Formatters::BaseFormatter
      attr_accessor :matrix

      def initialize(output)
        super(output)
        @matrix = matrix
      end

      def start(expected_example_count)
        @matrix ||= MatrixFormatter::FeatureMatrix.new
      end

      def example_group_started(example_group)
        description = example_group.description
        if @matrix.implementors.include? description
          @matrix.current_implementor = description
        else
          @matrix.current_product = description
        end
      end

      def example_started(example)
        @matrix.current_feature = example.description
      end

      def example_passed(example)
        @matrix.add_result :passed
      end

      def example_failed(example)
        @matrix.add_result :failed
      end

      def example_pending(example)
        @matrix.add_result :pending
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        # don't
      end
    end
  end
end
