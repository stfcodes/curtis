# Curtis

Extremely light wrapper around ncurses-ruby.

## Installation

Use the GitHub url in your Gemfile for now. RubyGems coming soon.

## Usage

Below is a really simple example:

```ruby
require 'curtis'

# The #show method is the starting point.
# `screen` here is the standard screen, and is the #parent of other views.
Curtis.show do |screen|
  screen.justify 'Welcome to Curtis. A simple ncurses-ruby wrapper.'
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
    v.lines   = v.parent.lines / 2
    v.columns = v.parent.columns / 2
    v.line    = v.parent.lines / 2
    v.column  = v.parent.columns / 2
  end

  # Fill the `lower_right` view with the letter 'R'
  0.upto lower_right.lines do |line|
    lower_right.move_cursor line: line
    lower_right.addstr 'R' * lower_right.columns
  end

  # Actually show the contents of `lower_right`
  lower_right.render

  screen.move_cursor line: screen.lines / 4
  screen.justify '[Q]uit!'

  # Press 'q' to stop the input loop
  Curtis::Input.get do |key|
    break if key == 'q'
  end
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

