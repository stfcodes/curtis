require 'curtis'

# The #show method is the starting point.
# `screen` here is the standard screen, and is the #parent of other views.
Curtis.show do |screen|
  screen.puts 'Welcome to Curtis. A simple ncurses-ruby wrapper.', h: :center
  screen.render

  # Initialize a new View via keyword arguments.
  # All attributes are optional and can be set at a later time.
  lower_left = Curtis::View.new(lines: screen.lines / 2, columns: screen.columns / 2, line: screen.lines / 2)

  # Fill the lower_left view with the letter 'L'
  0.upto lower_left.lines do |line|
    lower_left.move_cursor line: line
    lower_left.addstr 'L' * lower_left.columns
  end

  # Actually show the contents of `lower_left`
  lower_left.render

  # Initialize a new View via block, and using fancy percentages
  lower_right = Curtis::View.new do |v|
    v.lines   = v.parent.lines
    v.columns = v.parent.columns
    v.line    = v.parent.lines
    v.column  = v.parent.columns
  end

  # Fill the `lower_right` view with the letter 'R'
  0.upto lower_right.lines do |line|
    lower_right.move_cursor line: line
    lower_right.addstr 'R' * lower_right.columns
  end

  # Actually show the contents of `lower_right`
  lower_right.render

  screen.move_cursor line: screen.lines
  screen.puts '[Q]uit!', h: :center

  # Press 'q' to stop the input loop
  Curtis::Input.get do |key|
    break if key == 'q'
  end
end
