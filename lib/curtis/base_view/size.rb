module Curtis
  class BaseView
    class Size
      attr_reader :window

      def initialize(window)
        @window = window
      end

      def lines
        lines_and_columns.first
      end

      def columns
        lines_and_columns.last
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
