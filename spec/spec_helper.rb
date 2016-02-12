require 'simplecov'
SimpleCov.add_filter('spec')
SimpleCov.start unless SimpleCov.running

require 'bundler/setup'
require 'curtis'

# Minitest
require 'minitest/mock'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'

# :nodoc: all
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
