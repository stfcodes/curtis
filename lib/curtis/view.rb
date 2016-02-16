require 'forwardable'
require 'curtis/view/all'
require 'curtis/helpers/all'

module Curtis
  class View
    extend Forwardable
    include Helpers::Text
    include Helpers::Border

    # The name of the view
    attr_reader :name
    # Holds the ncurses window object
    attr_reader :window
    # Allows easier tracking of the window size
    attr_reader :size
    # Allows easier tracking of the cursor position
    attr_reader :cursor
    # Allows easier tracking of the window position
    attr_reader :position
    # Various setters for sizing and positioning
    attr_writer :lines, :line, :columns, :column

    # Delegators
    def_delegators :size,     :lines, :columns
    def_delegators :position, :line,  :column

    class << self
      def screen
        @screen ||= self.new(Ncurses.stdscr)
      end
    end

    def initialize(ncurses_window = nil, **opts, &block)
      validate_window!(ncurses_window)

      @lines     = opts.fetch(:lines)   { -> { parent.size.lines } }
      @columns   = opts.fetch(:columns) { -> { parent.size.columns } }
      @line      = opts.fetch(:line)    { 0 }
      @column    = opts.fetch(:column)  { 0 }

      @cursor   = Cursor.new(self)
      @size     = Size.new(self)
      @position = Position.new(self)

      use_dsl(&block) if block_given?

      @window   = ncurses_window || computed_window
    end

    def parent
      self.class.screen
    end

    def draw(&block)
      instance_eval &block
      self
    end

    def render(every: 0.04)
      clear_thread!
      window.refresh unless block_given?

      @thread = Thread.new do
        loop do
          yield self
          window.refresh
          sleep(every)
        end
      end
    end

    def clear(also_thread: true)
      clear_thread! if also_thread
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

    def move_cursor(line: 0, column: 0)
      window.move(line, column)
    end

    def method_missing(method_name, *arguments, &block)
      return super unless window.respond_to?(method_name)
      window.send(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      window.respond_to?(method_name) || super
    end

    private

    def computed_window
      Ncurses::WINDOW.new(*computed_dimensions, *computed_coordinates)
    end

    def dimensions
      [@lines, @columns]
    end

    def coordinates
      [@line, @column]
    end

    def computed_dimensions
      dimensions.map! do |d|
        d.respond_to?(:call) ? d.call : d
      end
    end

    def computed_coordinates
      coordinates.map! do |d|
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

    def validate_window!(ncurses_window)
      return unless ncurses_window

      unless ncurses_window.kind_of?(Ncurses::WINDOW)
        fail ArgumentError, 'Only Ncurses::WINDOW instances allowed.'
      end
    end

    def use_dsl(&block)
      if block.arity == 1
        yield self
      else
        instance_eval &block
      end
    end
  end
end
