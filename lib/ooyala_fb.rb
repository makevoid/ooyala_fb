
# The FacebookSharing kit is a set of methods which enable publishers to insert the meta tags
# required by all videos being uploaded to Facebook.
# The Develop Kit contains a primary class FacebookSharing, and one primary method: header().


require "base64"
require "cgi"
require "digest/sha2"
require "open-uri"
require 'net/http'
require 'rexml/document'
require 'logger'

# The logging level is set to INFO by default. Change it to Logger::ERROR if
# info messages about missing attribute values need not be logged in the file
# in the initialize method.

class OoyalaFb

  QUERY_EXPIRES_IN = 1000

  # Maximum width allowed for facebook videos. If the video being uploaded
  # has a width greater than this, it will be reduced to make the width
  # the same as FACEBOOK_MAX_WIDTH while maintaining the same aspect ratio
  # between height and width.
  
  FACEBOOK_MAX_WIDTH = 420

  def initialize (partner_code, secret_code)
    @partner_code = partner_code
    @secret_code  = secret_code

    # Create a logger which ages logfile once it reaches
    # a certain size. Leave 10 "old log files" and each file is about 1,024,000 bytes.
    $LOG = Logger.new('ooyala_fb.log', 10, 1024000)

    # Set the default logging level to INFO. So it will print messages
    # about missing attribute values in the FacebookSharing.log file.
    # Change this to Logger:ERROR if the messages should not be logged.
    $LOG.sev_threshold = Logger::INFO

  end
 
  # Returns the string containing meta tags required by videos being uploaded to facebook
  # for the given embed code, partner code and secret code video.

  def header (embed_code)
    # Get the url for the passed in partner_code, secret_code and embed_code
    url = get_url('embedCode'=> embed_code)

    # Get the xml data for the url.
    xml_data = Net::HTTP.get_response(URI.parse(url)).body

    # Parse the xml document to get the values for creating meta tags
    doc = REXML::Document.new(xml_data)

    # Fill the hash map with the key value pairs for the required meta tags
    # by getting the values from the parsed xml
    tags     = ['title', 'description', 'thumbnail', 'height', 'width', 'embedCode']
    metadata = {}
    tags.map{|tag| metadata[tag] = get_node_value(doc, tag, embed_code)}

    # Adjust video width to max allowed by Facebook, if required.
    if metadata['width'] != nil
      if Integer(metadata['width']) > FACEBOOK_MAX_WIDTH
        metadata['height'] = get_adjusted_height(Integer(metadata['width']), Integer(metadata['height']))
        metadata['width']  = FACEBOOK_MAX_WIDTH
      end
    end
		
    # Construct the meta tags string by substituting the values from the metadata hashmap.
    meta_tags = %Q{
      <meta name="medium" content="video" />
      <meta name="title" content="#{metadata['title']}" />
      <meta name="description" content="#{metadata['description']}" />
      <link rel="image_src" href="#{metadata['thumbnail']}" />
      <link rel="video_src" href="http://player.ooyala.com/player.swf?\
embedCode=#{metadata['embedCode']}&keepEmbedCode=true" />
      <meta name="video_height" content="#{metadata['height']}" />
      <meta name="video_width" content="#{metadata['width']}" />
      <meta name="video_type" content="application/x-shockwave-flash" />
    }

    # return the meta tags string with the values retrieved for the embedCode
    return meta_tags
  end

  private
  
  # Gets the value for the node passed in from the xml document passed in.
  def get_node_value (doc, node_name, embed_code)

    node_value = doc.get_elements("list/item/#{node_name}")[0].get_text().value rescue nil
  
    if @node_value == nil
      $LOG.info("Value not found for: #{node_name}, embed_code:  #{embed_code}")
    end

    return node_value
  end

  def get_url (params)
    # Gets the url for the partner_code, secret_code and embedCode
    # passed in while creating an object of FacebookSharing class.
    params["expires"] ||= (Time.now.to_i + QUERY_EXPIRES_IN).to_s

    string_to_sign = @secret_code
    url 	   = "http://api.ooyala.com/partner/query?pcode=#{@partner_code}"

    params.keys.sort.each do |key|
      string_to_sign += "#{key}=#{params[key]}"
      url += "&#{CGI.escape(key)}=#{CGI.escape(params[key])}"
    end

    digest    = Digest::SHA256.digest(string_to_sign)
    signature = Base64::encode64(digest).chomp.gsub(/=+$/, '')
    url      += "&signature=#{CGI.escape(signature)}"
    return url
  end

  # returns the new height for any video which has width > FACEBOOK_MAX_WIDTH
  # by mainting the same aspect ratio, considering that the width will be
  # brought down to FACEBOOK_MAX_WIDTH
  def get_adjusted_height (width, height)
    return width == 0 ? 0 : (height.to_f * FACEBOOK_MAX_WIDTH.to_f / width.to_f).to_i
  end

end


