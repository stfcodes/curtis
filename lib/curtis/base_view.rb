require 'curtis/base_view/all'
require 'curtis/helpers/all'

module Curtis
  class BaseView
    attr_reader :cursor, :size, :position
    attr_reader :window

    include Helpers::Text
    include Helpers::Border

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

    def cursor=(*args)
      line, column = args.flatten.first, args.flatten.last
      window.move(line, column)
    end

    def size=(*args)
      lines, columns = args.flatten.first, args.flatten.last
      window.resize(lines, columns)
    end

    def position=(*args)
      line, column = args.flatten.first, args.flatten.last
      window.clear
      window.refresh
      window.mvwin(line, column)
    end
  end
end
