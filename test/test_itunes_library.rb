#######################################################################
# test_itunes_library.rb
#
# Test suite for the main library.
#######################################################################
require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'itunes_library'

class TC_ITunesLibrary < Test::Unit::TestCase
  test( "version number is set to expected value" ) do
    assert_equal('0.0.1', ITunesLibrary::VERSION)
  end
end
