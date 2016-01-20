# This example shows a box centered on the screen, and an auto-updating
# timestamp. You can also resize the screen to see that the box
# remains centered.

require 'curtis'

Curtis.show do |screen|
  # Use lambdas for dimensions and coordinates,
  # so that subsequent calls to #resize, and #reposition
  # can be done without recalculating the new size, or position.
  center = Curtis::View.new do |v|
    v.lines   = -> { v.parent.lines / 2 }
    v.columns = -> { v.parent.columns / 2 }
    v.line    = -> { v.parent.lines / 4 }
    v.column  = -> { v.parent.columns / 4 }
  end

  center.border
  center.move_cursor line: center.lines / 2
  # Do the operation encolsed in the block every 100 milliseconds
  # in a different thread. #close ensures that the thread is stopped.
  center.render every: 0.1 do
    center.justify Time.now.strftime('%H:%M:%S.%L')
  end

  # Curtis::Keyboard.input with a block starts a loop
  Curtis::Keyboard.input do |key|
    break if key != :resize

    # Redraw the screen
    screen.clear
    screen.render

    # Redraw the viewl
    center.clear
    center.resize
    center.reposition

    center.border
    center.move_cursor line: center.lines / 2
    center.render every: 0.1 do
      center.justify Time.now.strftime('%H:%M:%S.%L')
    end
  end
end
