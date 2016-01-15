require 'curtis/base_view'

module Curtis
  class View < BaseView

    attr_writer :height, :width, :row, :col

    def initialize(**args)
      yield self if block_given?

      h = args[:height] || @height
      w = args[:width]  || @width
      r = args[:row]    || @row     || 0
      c = args[:col]    || @col     || 0

      ncurses_window = Ncurses::WINDOW.new(h, w, r, c)
      super ncurses_window
    end

    def render(every: 0.04)
      refresh unless block_given?

      Thread.new do
        loop do
          yield self
          refresh
          sleep every
        end
      end
    end

  end
end
