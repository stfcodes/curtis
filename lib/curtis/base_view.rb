require 'forwardable'
require 'curtis/base_view/all'
require 'curtis/helpers/all'

module Curtis
  class BaseView
    extend Forwardable

    attr_reader :cursor, :size, :position
    attr_reader :window

    include Helpers::Text
    include Helpers::Border

    def_delegators :size,     :lines, :columns
    def_delegators :position, :line,  :column

    def initialize(ncurses_window = Ncurses.stdscr)
      unless ncurses_window.kind_of? Ncurses::WINDOW
        fail ArgumentError, 'Only Ncurses::WINDOW instances allowed.'
      end

      @window   = ncurses_window
      @cursor   = Cursor.new(self)
      @size     = Size.new(self)
      @position = Position.new(self)
    end

    def method_missing(method_name, *arguments, &block)
      return super unless window.respond_to?(method_name)
      window.send(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      window.respond_to?(method_name) || super
    end

    def parent
      window
    end

    def render
      window.refresh
    end

    def move_cursor(line: 0, column: 0)
      window.move(line, column)
    end
  end
end
