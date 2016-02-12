module Curtis
  module Helpers
    module Text

      def puts(text, column: nil, line: nil)
        # Clean up input
        lines = text.kind_of?(String) ? text.split("\n") : text
        lines = lines.dup.map! { |line| line.chars.map(&:ord) }

        # Calculate the starting line
        line  = translate_line(line, lines: lines.size)

        # Iterate over each line..
        lines.each do |text|
          # Actually move the cursor (before adding the string),
          # to the calculated line, and the calculated column for that line
          window.move line, translate_column(column, columns: text.size)

          # Actually add the text, without moving the cursor.
          # Not using #addstr because it moves the cursor and fails
          # for the last character of the line
          window.addchstr text

          # Increment the line
          line += 1
        end
      end

      private

      def translate_text(text)
        text.chars.map(&:ord)
      end

      def translate_column(value, columns:)
        return cursor.column if value.nil?
        return value unless value.is_a?(Symbol)

        case value
        when :left    then 0
        when :center  then (size.columns - columns) / 2
        when :right   then size.columns - columns
        end
      end

      def translate_line(value, lines:)
        return cursor.line if value.nil?
        return value unless value.is_a?(Symbol)

        case value
        when :top    then 0
        when :center then (size.lines - lines) / 2
        when :bottom then size.lines  - lines
        end
      end
    end
  end
end
