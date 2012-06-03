require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'itunes-dedup'
  spec.version    = '0.0.1'
  spec.author     = 'Ben Nagy'
  spec.license    = 'MIT'
  spec.email      = 'github@ben.iagu.net'
  spec.homepage   = 'https://github.com/bnagy/itunes-dedup'
  spec.summary    = 'A dangerously broken iTunes duplicate remover'
  spec.test_files = Dir['test/*.rb']
  spec.files      = Dir['**/*'].delete_if{ |item| item.include?('git') }
  spec.executables      = 'itunes-dedup'


  spec.extra_rdoc_files = ['CHANGES', 'README.md', 'MANIFEST']

  spec.add_dependency('nokogiri')
  spec.add_dependency('trollop')
  spec.add_development_dependency('test-unit')

  spec.description = <<-EOF
iTunes Deduper. Default strategy is to prefer highest bitrate.

'deleted' files will be moved to deleted_itunes_tracks in your home directory.

NOTE: This only moves files around - they will still show up in your iTunes
library until you delete your iTunes Music Library.xml and re-import your music. 

IMPORTANT: This script will probably not work / kill your cat / set your
computer on fire.  Do not use for any reason.
  EOF
end
