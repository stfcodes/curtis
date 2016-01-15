require 'ncurses'

require 'curtis/version'
require 'curtis/base_view'
require 'curtis/view'
require 'curtis/keyboard'

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
      Ncurses.cbreak if config.cbreak
      Ncurses.noecho if config.noecho
      Ncurses.curs_set(0) if config.hide_cursor
      screen.refresh
      yield BaseView.new(screen)
    ensure
      Ncurses.endwin
    end
  end

  class Configuration
    attr_accessor :cbreak
    attr_accessor :noecho
    attr_accessor :hide_cursor

    def initialize
      @cbreak      = true
      @noecho      = true
      @hide_cursor = false
    end
  end
end
