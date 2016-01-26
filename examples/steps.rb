# Views in this example are initialized with defaults.

require 'curtis'

Curtis.show do |screen|
  first = Curtis::View.new
  first.border
  first.move_cursor line: first.lines / 2
  first.justify 'This is step 1.'
  first.cursor.newline!
  first.justify 'Press any key...'
  first.render

  Curtis::Input.get
  first.delwin
  screen.clear
  screen.render

  second = Curtis::View.new
  second.border
  second.move_cursor line: second.lines / 2
  second.justify 'Step 2.'
  second.cursor.newline!
  second.justify 'Press any key to quit.'
  second.render
  Curtis::Input.get
end
