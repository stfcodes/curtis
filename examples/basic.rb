#!/usr/bin/env ruby
require 'bundler/setup'
require 'curtis'

# Configure Curtis with a block
Curtis.configure do |config|
  config.hide_cursor = true
end

# Or by passing the exact configuration option
# Curtis.config.hide_cursor = true

# The #show method is the starting point. `screen` here is the main view
# Other views are created inside this main view (BaseView)
Curtis.show do |screen|
  # #justify is a utility method for centering text inside a window
  screen.justify 'Welcome to Curtis. A simple ncurses-ruby wrapper.'

  # Return the width and height of the main view, in rows and columns.
  half_w = screen.width / 2
  half_h = screen.height / 2

  # Initialize a new View via keyword arguments
  # `width` and `height` are mandatory
  # `row` and `col` default to zero
  lower_left = Curtis::View.new(height: half_h, width: half_w, row: half_h)

  # Fill the lower_left view with the letter 'L'
  0.upto lower_left.height do |row|
    lower_left.mvaddstr row, 0, 'L' * lower_left.width
  end

  # Actually show the contents of `lower_left`
  lower_left.refresh

  # Initialize a new View via block
  lower_right = Curtis::View.new do |v|
    v.height  = lower_left.height
    v.width   = lower_left.width
    v.row     = screen.height / 2
    v.col     = screen.width / 2
  end

  # Fill the `lower_right` view with the letter 'R'
  0.upto lower_right.height do |row|
    lower_right.mvaddstr row, 0, 'R' * lower_right.width
  end

  # Actually show the contents of `lower_right`
  lower_right.refresh

  screen.move screen.height / 4, 0
  screen.justify 'Press any key to [Q]uit!'

  # Wait for any keypress before stopping
  screen.getch
end
