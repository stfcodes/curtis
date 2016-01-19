require 'curtis/base_view'

module Curtis
  class View < BaseView

    attr_writer :lines, :columns, :line, :column

    def initialize(**args)
      yield self if block_given?

      h = args[:lines]    || @lines     || parent.size.lines
      w = args[:columns]  || @columns   || parent.size.columns
      r = args[:line]     || @line      || 0
      c = args[:column]   || @column    || 0

      ncurses_window = Ncurses::WINDOW.new(h, w, r, c)
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
