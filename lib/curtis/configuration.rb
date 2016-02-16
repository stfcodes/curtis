module Curtis
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
