require 'curtis/base_view'

module Curtis
  class View < BaseView
    attr_writer :lines, :line, :columns, :column

    def initialize(lines: parent.size.lines, columns: parent.size.columns, line: 0, column: 0)
      @lines    = lines
      @columns  = columns
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
      refresh unless block_given?

      @thread = Thread.new do
        loop do
          yield self
          refresh
          sleep every
        end
      end
    end

    def clear
      clear_thread!
      super
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
