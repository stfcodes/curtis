module Curtis
  module Helpers
    module Text
      def justify(text, align: :center)
        column = case align
                 when :center then (size.columns - text.size) / 2
                 when :right then (size.columns - text.size)
                 end
        window.mvaddstr cursor.line, column, text
      end
    end
  end
end
