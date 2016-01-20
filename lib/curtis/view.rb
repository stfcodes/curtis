require 'curtis/base_view'

module Curtis
  class View < BaseView
    attr_writer :lines, :line, :columns, :column

    def initialize(lines: nil, columns: nil, line: 0, column: 0)
      @lines    = lines   || parent.size.lines
      @columns  = columns || parent.size.columns
      @line     = line
      @column   = column

      yield self if block_given?

      ncurses_window = Ncurses::WINDOW.new(@lines, @columns, @line, @column)
      super ncurses_window
    end

    def parent
      @parent ||= self.class.superclass.new(Ncurses.stdscr)
    end

    def render(every: 0.04)
      clear_thread!
      window.refresh unless block_given?

      @thread = Thread.new do
        loop do
          yield self
          window.refresh
          sleep every
        end
      end
    end

    def clear
      clear_thread!
      window.clear
    end

    def resize(lines, columns)
      window.resize(lines, columns)
    end

    def reposition(line, column)
      window.mvwin(line, column)
    end

    private

    def clear_thread!
      @thread.terminate if running_thread?
      @thread = nil unless @thread.nil?
    end

    def running_thread?
      !@thread.nil? && @thread.alive?
    end
  end
end
