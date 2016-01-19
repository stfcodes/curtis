module Curtis
  module Helpers
    module Text
      def justify(text, align: :center)
        column = case align
                 when :center then (width - text.size) / 2
                 when :right then (width - text.size)
                 end
        window.mvaddstr row, column, text
      end
    end
  end
end
