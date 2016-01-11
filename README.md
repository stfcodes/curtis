# Curtis

Extremely light wrapper around ncurses-ruby.

## Installation

Install it yourself as or use it in your gemfile as `gem curtis`:

## Usage

Below is a really simple example:

```ruby
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
  # #justify_center is a utility method for centering text inside a window
  screen.justify_center 'Welcome to Curtis. A simple ncurses-ruby wrapper.'

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
  screen.justify_center 'Press any key to [Q]uit!'

  # Wait for any keypress before stopping
  screen.getch
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

* Tests (how? srlsy)
* Keyboard handler
* Add more Ncurses options
* Improve readme

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shuriu/curtis.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

