module Curtis
  class BaseView
    attr_reader :window

    def initialize(ncurses_window)
      unless ncurses_window.kind_of? Ncurses::WINDOW
        fail ArgumentError, 'Only Ncurses::WINDOW instances allowed.'
      end

      @window = ncurses_window
    end

    # Maximum vertical size.
    def height
      rows_and_cols.first
    end

    # Maximum horizontal size.
    def width
      rows_and_cols.last
    end

    # The row where the cursor is positioned at right now.
    def row
      cursor_row_and_col.first
    end

    # The column where the cursor is positioned at right now.
    def col
      cursor_row_and_col.last
    end

    # Assumes cursor is already positioned on the row
    def justify_center(text)
      column = (width - text.size) / 2
      window.mvaddstr row, column, text
    end

    def justify_right(text)
      column = (width - text.size)
      @window.mvaddstr row, column, text
    end

    # TODO: Good enough for now
    def method_missing(method_name, *arguments, &block)
      return super unless window.respond_to?(method_name)
      window.send(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      window.respond_to?(method_name) || super
    end

    private

    def rows_and_cols
      rows, cols = [], []
      window.getmaxyx(rows, cols)
      [rows.first, cols.first]
    end

    def cursor_row_and_col
      row, col = [], []
      window.getyx(row, col)
      [row.first, col.first]
    end
  end
end
