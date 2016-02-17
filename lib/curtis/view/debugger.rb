module Curtis
  class View
    class Debugger

      # Holds a reference to the view
      attr_reader :view

      def initialize(view)
        @view = view
      end

      def dump
        {
          name:     view.name,
          size:     size,
          position: position,
          cursor:   cursor,
          data:     data
        }
      end

      def size
        view.size.lines_and_columns
      end

      def position
        view.position.line_and_column
      end

      def cursor
        view.cursor.line_and_column
      end

      def data
        result = []

        # Remember the cursor position
        line, column = *cursor

        # Move the cursor to the first position
        view.move_cursor(line: 0, column: 0)

        # Iterate through all the lines and each line to the result array
        view.lines.times do
          output = ''
          view.window.winstr(output)
          result << output
        end

        # Move the cursor back to the initial position
        view.move_cursor(line: line, column: column)

        result
      end

    end
  end
end
