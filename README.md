# Ooyala Fb

### easilly enables meta tag creation on your ruby/rails/rack app for Ooyala Facebook sharing

this is the code found on: http://www.ooyala.com/support/docs/facebook_sharing_sdk
repackaged as a gem 

You can find your Partner and Secret codes under the Developers area of the Backlot Account tab.


## Install:
    gem install ooyala_fb


### In your Gemfile:
from rubygems:

    gem "ooyala_fb"
or from the git repo:

    gem "ooyala_fb", :git => "git://github.com/makevoid/ooyala_fb" 


## Usage:
    require "ooyala_fb"
    fbs = OoyalaFb.new partner_code: 'lxN2o63vhDmltiPGrrBoRLs6Mdpe', secret_code: 'bhBuI1mEzvu4MgSpuJvZdl1oiXZNrCGJ69CYiuMU' 
    
    puts fbs.header 'libjV0MTomg4gFR1h9S2zONQdqRXiZUu'
  
  

### Changes:
- 0.2.2 - constructor takes an hash as argument, logger is now optional
- 0.2.1 - first release


    