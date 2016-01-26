module Curtis
  class BaseView
    class Size
      attr_reader :view

      def initialize(view)
        @view = view
      end

      def lines
        lines_and_columns.first
      end

      def columns
        lines_and_columns.last
      end

      def lines_and_columns
        lines, columns = [], []
        view.window.getmaxyx(lines, columns)
        [lines.first, columns.first]
      end

      def to_s
        lines_and_columns.join(', ')
      end
    end
  end
end
