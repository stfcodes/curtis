require 'curtis/refinements/numeric'

module Curtis
  class BaseView
    class Size
      using NumericRefinements

      attr_reader :window

      def initialize(window)
        @window = window
      end

      def lines(p: nil)
        return lines_and_columns.first unless p
        lines_and_columns.first.percent(p)
      end

      def columns(p: nil)
        return lines_and_columns.last unless p
        lines_and_columns.last.percent(p)
      end

      def lines_and_columns
        lines, columns = [], []
        window.getmaxyx(lines, columns)
        [lines.first, columns.first]
      end

      def to_s
        lines_and_columns.join(', ')
      end
    end
  end
end
