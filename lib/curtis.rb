begin
  require 'pry'
  require 'binding_of_caller'
rescue LoadError => e
end

require 'ncurses'
require 'curtis/version'
require 'curtis/base_view'
require 'curtis/view'
require 'curtis/input'

module Curtis
  class << self
    def config
      @config ||= Configuration.new
      yield @config if block_given?
      @config
    end
    alias_method :configure, :config

    def show
      initialize_ncurses
      yield screen
    ensure
      close_ncurses
    end

    def screen
      @screen ||= BaseView.new(Ncurses.stdscr)
    end

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
      Ncurses.stdscr.refresh
    end

    def close_ncurses
      @screen = nil
      Ncurses.endwin
    end
  end

  class Configuration
    ATTRIBUTES = %i(
      interactive use_keypad hide_cursor
    ).freeze

    attr_accessor *ATTRIBUTES

    def initialize
      @interactive = true
      @use_keypad  = false
      @hide_cursor = true
    end
  end
end
