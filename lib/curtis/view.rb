require 'curtis/base_view'
require 'curtis/refinements/all'

module Curtis
  class View < BaseView
    using StringRefinements
    using NumericRefinements

    def initialize(lines: parent.size.lines, columns: parent.size.columns, line: 0, column: 0)
      self.lines    = lines
      self.columns  = columns
      self.line     = line
      self.column   = column

      yield self if block_given?

      ncurses_window = Ncurses::WINDOW.new(@lines, @columns, @line, @column)
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

    def resize(lines, columns)
      lines   = handle_relative(lines, total: parent.size.lines)
      columns = handle_relative(columns, total: parent.size.columns)
      window.resize(lines, columns)
    end

    def move(line, column)
      line   = handle_relative(line, total: parent.size.lines)
      column = handle_relative(column, total: parent.size.columns)
      window.mvwin(line, column)
    end

    def line=(value)
      @line = handle_relative(value, total: parent.size.lines)
    end

    def lines=(value)
      @lines = handle_relative(value, total: parent.size.lines)
    end

    def column=(value)
      @column = handle_relative(value, total: parent.size.columns)
    end

    def columns=(value)
      @columns = handle_relative(value, total: parent.size.columns)
    end

    private

    def clear_thread!
      @thread.terminate if running_thread?
      @thread = nil unless @thread.nil?
    end

    def running_thread?
      !@thread.nil? && @thread.alive?
    end

    def handle_relative(value, total:)
      return value unless value.relative?
      value.relative.percent_of(total)
    end
  end
end
