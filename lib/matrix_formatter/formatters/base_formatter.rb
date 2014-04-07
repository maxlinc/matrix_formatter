require 'rspec/core/formatters/base_text_formatter'

module MatrixFormatter
  module Formatters
    module BaseFormatter
      attr_accessor :matrix

      def start(expected_example_count)
        @matrix ||= MatrixFormatter::FeatureMatrix.new
      end

      def example_group_started(example_group)
        description = example_group.description
        if example_group.top_level?
          @matrix.add_product example_group
        else
          @matrix.add_feature example_group
        end
      end

      def example_passed(example)
        @matrix.add_implementation_result :passed, example
      end

      def example_failed(example)
        @matrix.add_implementation_result :failed, example
      end

      def example_pending(example)
        @matrix.add_implementation_result :pending, example
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        # don't
      end
    end
  end
end
