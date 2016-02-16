module Curtis
  class View
    class Cursor
      attr_reader :view

      def initialize(view)
        @view = view
      end

      def line
        line_and_column.first
      end

      def line=(new_line, reset_column: true)
        new_column = reset_column ? 0 : column
        view.window.move new_line, new_column
      end

      def column
        line_and_column.last
      end

      def column=(new_column)
        view.move line, new_column
      end

      def rewind!
        view.move 0, 0
      end

      def newline!
        view.move line + 1, 0
      end

      def line_and_column
        line, column = [], []
        view.window.getyx(line, column)
        [line.first, column.first]
      end

      def to_s
        line_and_column.join(', ')
      end
    end
  end
end
