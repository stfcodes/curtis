
require 'curtis/version'
require 'ncurses'
require 'curtis/base_view'
require 'curtis/view'

module Curtis
  class << self
    def config
      @config ||= Configuration.new
      yield @config if block_given?
      @config
    end
    alias_method :configure, :config

    def show(**options)
      screen = Ncurses.initscr
      Ncurses.cbreak
      Ncurses.noecho
      Ncurses.curs_set(0) if config.hide_cursor
      screen.refresh
      yield BaseView.new(screen)
    ensure
      Ncurses.endwin
    end
  end

  class Configuration
    attr_accessor :hide_cursor

    def initializes
      @hide_cursor = false
    end
  end
end
