require 'curtis/base_view'

module Curtis
  class View < BaseView
    attr_writer :lines, :line, :columns, :column

    def initialize(**opts)
      @lines     = opts[:lines]   || -> { parent.size.lines }
      @columns   = opts[:columns] || -> { parent.size.columns }
      @line      = opts[:line]    || 0
      @column    = opts[:column]  || 0

      yield self if block_given?

      super Ncurses::WINDOW.new(*computed_dimensions, *computed_coordinates)
    end

    def parent
      BaseView.instance
    end

    def render(every: 0.04)
      clear_thread!

      if block_given?
        @thread = Thread.new do
          loop do
            yield self
            window.refresh
            sleep every
          end
        end
      else
        setup
        window.refresh
      end
    end

    def clear
      clear_thread!
      window.clear
    end

    def resize(lines: nil, columns: nil)
      @lines   = lines   if lines
      @columns = columns if columns
      window.resize(*computed_dimensions)
    end

    def reposition(line: nil, column: nil)
      @line   = line   if line
      @column = column if column
      window.mvwin(*computed_coordinates)
    end

    private

    def dimensions
      [@lines, @columns]
    end

    def coordinates
      [@line, @column]
    end

    def computed_dimensions
      dimensions.map do |d|
        d.respond_to?(:call) ? d.call : d
      end
    end

    def computed_coordinates
      coordinates.map do |d|
        d.respond_to?(:call) ? d.call : d
      end
    end

    def clear_thread!
      @thread.terminate if running_thread?
      @thread = nil unless @thread.nil?
    end

    def running_thread?
      !@thread.nil? && @thread.alive?
    end
  end
end
