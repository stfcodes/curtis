module Curtis
  module Helpers

    def self.included(base)
      fail 'Target must respond to #window.' unless base.method_defined?(:window)
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
    def justify(text, align: :center)
      column = case align
               when :center then (width - text.size) / 2
               when :right then (width - text.size)
               end
      window.mvaddstr row, column, text
    end

    def box(ns: 0, we: 0)
      super ns.ord, we.ord
    end

    def border(n: 0, ne: 0, e: 0, se: 0, s: 0, sw: 0, w: 0, nw: 0)
      borders = [w, e, n, s, nw, ne, sw, se].map(&:ord)
      super *borders
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
