module Curtis
  class BaseView
    class Position
      attr_reader :view

      def initialize(view)
        @view = view
      end

      def line
        line_and_column.first
      end

      def column
        line_and_column.last
      end

      def bottom

      end

      def line_and_column
        line, column = [], []
        view.window.getbegyx(line, column)
        [line.first, column.first]
      end

      def to_s
        line_and_column.join(', ')
      end
    end
  end
end
