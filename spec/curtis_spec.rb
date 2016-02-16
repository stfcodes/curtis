require 'spec_helper'

describe Curtis do
  it 'has a version number' do
    refute_nil Curtis::VERSION
  end

  describe '.show' do
    it 'yields with the standard screen argument' do
      has_screen = false
      Curtis.show { |s| has_screen = !!s }
      has_screen.must_equal true
    end

    it 'does not work without a block' do
      proc { Curtis.show }.must_raise LocalJumpError
    end
  end

  describe '.config' do
    it 'has a configuration attached' do
      Curtis.config.must_be_kind_of Curtis::Configuration
    end

    it 'has many configuration options' do
      attributes = Curtis::Configuration::ATTRIBUTES.dup.map! do |a|
        [a, :"#{a}="]
      end.flatten.sort
      methods = (Curtis::Configuration.instance_methods - Object.methods).sort
      methods.must_equal attributes
    end

    it 'has default options' do
      config = Curtis::Configuration.new
      config.interactive.must_equal true
      config.hide_cursor.must_equal true
      config.use_keypad.must_equal  false
    end

    it 'allows configuration via a block' do
      Curtis.config do |c|
        c.interactive = false
      end
      Curtis.config.interactive.must_equal false
    end
  end
end
