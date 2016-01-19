require 'curtis/base_view'

module Curtis
  class View < BaseView

    attr_writer :height, :width, :row, :col

    def initialize(**args)
      yield self if block_given?

      h = args[:height] || @height  || 0
      w = args[:width]  || @width   || 0
      r = args[:row]    || @row     || 0
      c = args[:col]    || @col     || 0

      ncurses_window = Ncurses::WINDOW.new(h, w, r, c)
      super ncurses_window
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
