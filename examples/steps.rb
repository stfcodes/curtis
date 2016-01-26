# Views in this example are initialized with defaults.

require 'curtis'

Curtis.show do |screen|
  first = Curtis::View.new
  first.border
  first.move_cursor line: first.lines / 2
  first.puts 'This is step 1.', h: :center
  first.cursor.newline!
  first.puts 'Press any key...', h: :center
  first.render

  Curtis::Input.get
  first.delwin
  screen.clear
  screen.render

  second = Curtis::View.new
  second.border
  second.move_cursor line: second.lines / 2
  second.puts 'Step 2.', h: :center
  second.cursor.newline!
  second.puts 'Press any key to quit.', h: :center
  second.render
  Curtis::Input.get
end
