# Usage:
# You can find your Partner and Secret codes under the Developers
# area of the Backlot Account tab

require 'ooyala_fb'
fbs = OoyalaFb.new('<your partner code>', '<your secret code>')

puts fbs.header('<video embed code>')
