require 'curtis/helpers'

module Curtis
  class BaseView

    attr_reader :window

    include Helpers

    def initialize(ncurses_window)
      unless ncurses_window.kind_of? Ncurses::WINDOW
        fail ArgumentError, 'Only Ncurses::WINDOW instances allowed.'
      end

      @window = ncurses_window
    end

    def method_missing(method_name, *arguments, &block)
      return super unless window.respond_to?(method_name)
      window.send(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      window.respond_to?(method_name) || super
    end
  end
end
