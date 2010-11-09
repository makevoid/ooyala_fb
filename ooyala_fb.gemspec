path = File.expand_path("../lib", __FILE__)
$:.unshift(path) unless $:.include?(path)
#require "mygem/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'ooyala_fb'
  s.version     = "0.2"
  s.summary     = 'easilly enable Ooyala Facebook sharing'
  s.description = 'see: http://www.ooyala.com/support/docs/facebook_sharing_sdk'

  s.author            = "Francesco 'makevoid' Canessa"
  s.email             = 'makevoid@gmail.com'
  s.homepage          = 'http://www.makevoid.com'
  # s.rubyforge_project = ''
  # list of 

  s.files        = Dir['README.md', "Rakefile", 'lib/**/*']
  s.require_path = 'lib'
end