path = File.expand_path("../lib", __FILE__)
$:.unshift(path) unless $:.include?(path)
#require "mygem/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'ooyala_fb'
  s.version     = "0.2.1"
  s.summary     = 'easilly enables meta tag creation on your ruby/rails/rack app for Ooyala Facebook sharing'
  s.description = 'easilly enables meta tag creation on your ruby/rails/rack app for Ooyala Facebook sharing - more infos: http://www.ooyala.com/support/docs/facebook_sharing_sdk'

  s.author            = "Ooyala! (modified by makevoid)"
  s.email             = 'makevoid@gmail.com'
  s.homepage          = 'http://www.makevoid.com'
  # s.rubyforge_project = ''
  # list of 

  s.files        = Dir['README.md', 'Rakefile', 'lib/**/*']
  s.require_path = 'lib'
end