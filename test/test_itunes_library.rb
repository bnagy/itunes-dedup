#######################################################################
# test_itunes_library.rb
#
# Test suite for the main library.
#######################################################################

require 'rubygems'
gem 'test-unit'
require 'test/unit'
require 'itunes_library'

class ITunesLibraryTest < Test::Unit::TestCase

    def test_version
        assert_equal('0.0.1', ITunesLibrary::VERSION)
    end

    def test_load
        assert_nothing_raised do
            ITunesLibrary.new(File.dirname(__FILE__) + '/mini.xml')
        end
    end

    def test_tracks
        i=ITunesLibrary.new(File.dirname(__FILE__) + '/mini.xml')
        assert_equal( i.tracks.size, 11 )
    end

    def test_abba
        i=ITunesLibrary.new(File.dirname(__FILE__) + '/mini.xml')
        assert_equal( i.tracks.select {|t| t.artist=='ABBA'}.size, 3 )
    end

end
