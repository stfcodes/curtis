begin
  require 'pry'
  require 'binding_of_caller'
rescue LoadError => e
end

require 'ncurses'
require 'curtis/version'
require 'curtis/configuration'
require 'curtis/view'
require 'curtis/input'

module Curtis
  class << self
    def show
      initialize_ncurses
      View.screen.render
      yield View.screen
    ensure
      close_ncurses
    end

    def view(name, &block)
      return views[name] unless block_given?
      views[name] = View.new(&block)
    end

    def views
      @views ||= {}
    end

    def config
      @config ||= Configuration.new
      yield @config if block_given?
      @config
    end
    alias_method :configure, :config

    private

    def initialize_ncurses
      Ncurses.initscr

      if config.interactive
        Ncurses.cbreak
        Ncurses.nonl
        Ncurses.noecho
      end

      Ncurses.stdscr.keypad(true) if config.use_keypad
      Ncurses.curs_set(0) if config.hide_cursor
    end

    def close_ncurses
      Ncurses.endwin
    end
  end
end
