require 'nokogiri'
require 'date'
require 'ostruct'
require 'delegate'
require 'uri'

# encoding: utf-8

class ITunesLibrary < DelegateClass( OpenStruct )

    def initialize itunes_file
        @db={}
        File.open( itunes_file, 'r' ) {|io|
            @parser=Nokogiri::XML::Reader io
            loop do
                node=@parser.read
                break unless node
                next if whitespace? node
                # The iTunes XML is basically just a deeply nested dict.
                if start_of_dict? node
                    @db=read_dict( node )
                end
            end
        }
        # flatten out the track list (keyed by Track ID), since the track_id is
        # an internal key anyway.
        @db[:tracks]=@db[:tracks].values.map {|h|
            # Change from a file:// URI to a local path. Probably broken if you
            # have stuff on shared disks, the internet etc etc
            h[:location]=URI.decode URI.parse( h[:location] ).path
            OpenStruct.new h
        }
        super OpenStruct.new( @db )
    end

    def inspect
        "iTunes Library: #{self.tracks.size} tracks."
    end

    private

    # A bit ugly, but it makes the rest of the code nicer.
    def start_of_element? node
        node.node_type==Nokogiri::XML::Reader::TYPE_ELEMENT
    end

    def end_of_element? node
        node.node_type==Nokogiri::XML::Reader::TYPE_END_ELEMENT
    end

    def start_of_dict? node
        node.node_type==Nokogiri::XML::Reader::TYPE_ELEMENT and node.name=='dict'
    end

    def end_of_dict? node
        node.node_type==Nokogiri::XML::Reader::TYPE_END_ELEMENT and node.name=='dict'
    end

    def start_of_array? node
        node.node_type==Nokogiri::XML::Reader::TYPE_ELEMENT and node.name=='array'
    end

    def end_of_array? node
        node.node_type==Nokogiri::XML::Reader::TYPE_END_ELEMENT and node.name=='array'
    end

    def whitespace? node
        node.node_type==Nokogiri::XML::Reader::TYPE_SIGNIFICANT_WHITESPACE || 
        node.node_type==Nokogiri::XML::Reader::TYPE_WHITESPACE
    end

    def snakey_symbolize str
        str.downcase.split(' ').join('_').to_sym
    end

    def read_element node
        contents=[]
        type=''

        # Get the element contents, if any, which may be split across
        # multiple text nodes, for some reason.
        loop do
            if start_of_dict? node
                return read_dict node
            elsif start_of_array? node
                return read_array node
            elsif start_of_element? node
                type=node.name
                break if type=='true' || type=='false' # no end of element
                until end_of_element? node
                    node=@parser.read
                    contents << node.value
                end
                break
            else
                # Skip stuff we don't know about, whitespace etc
                node=@parser.read
            end
        end

        # Use nice types
        case type
        when 'integer'
            Integer( contents.join )
        when *['string', 'key', 'data']
            contents.join
        when 'date'
            DateTime.parse contents.join
        when 'true'
            true
        when 'false'
            false
        else
            raise "Unknown content type #{type}"
        end

    end

    def read_array node
        ary=[]
        loop do
            node=@parser.read
            break if end_of_array? node
            next if whitespace? node
            ary << read_element( node )
        end
        ary
    end

    def read_dict node
        dict={}
        loop do
            node=@parser.read
            break if end_of_dict? node
            next if whitespace? node
            k,v=[ read_element( node ), read_element( node ) ]
            dict[snakey_symbolize(k)]=v
        end
        dict
    end

end
