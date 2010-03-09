require 'rubygems'

require 'cgi'
require 'curb'

module BlogPingingService

  class GoogleRequest
    SERVICE_URI = "http://blogsearch.google.com/ping"

    def initialize(name, uri, changes_url=nil)
      @params      = {
        'name' => name,
        'url'  => uri
      }
      @params['changesUrl'] = changes_url if changes_url
    end

    def query_string
      elements = []
      @params.keys.size.times do |i|
        elements << "#{@params.keys[i]}=#{CGI::escape(@params.values[i])}"
      end
      elements.join('&')
    end

    def perform
      c = Curl::Easy.new("#{SERVICE_URI}?#{query_string}") do |curl|
        curl.verbose = true
      end
      c.perform
      
      return c.body_str == 'Thanks for the ping.'
    end
  end

	class YahooRequest
    SERVICE_URI = "http://search.yahooapis.com/SiteExplorerService/V1/ping"

    def initialize(uri)
      @params      = {
        'sitemap' => uri,
      }
    end

    def query_string
      elements = []
      @params.keys.size.times do |i|
        elements << "#{@params.keys[i]}=#{CGI::escape(@params.values[i])}"
      end
      elements.join('&')
    end

    def perform
      c = Curl::Easy.new("#{SERVICE_URI}?#{query_string}") do |curl|
        curl.verbose = true
      end
      c.perform
      
      return c.body_str == 'Thanks for the ping.'
    end
	end

  def self.ping(name, uri, changes_url=nil)
    GoogleRequest.new(name, uri, changes_url).perform
    YahooRequest.new(uri).perform
  end

end

