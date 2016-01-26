module Curtis
  module Helpers
    module Text
      def puts(text, h: nil, v: nil)
        vertical    = case v
                      when :top then 0
                      when :center then size.lines / 2
                      when :bottom then size.lines - 1
                      else cursor.line
                      end

        horizontal  = case h
                      when :left then 0
                      when :center then (size.columns - text.size) / 2
                      when :right  then size.columns - text.size
                      else cursor.column
                      end

        window.mvaddstr vertical, horizontal, text
      end
    end
  end
end
