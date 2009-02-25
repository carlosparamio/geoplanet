%w{rubygems rest_client json}.each { |x| require x }

require 'geoplanet/version'
require 'geoplanet/base'
require 'geoplanet/place'

module GeoPlanet
  API_VERSION = "v1"
  API_URL     = "http://where.yahooapis.com/#{API_VERSION}/"
    
  class << self
    attr_accessor :appid
  end

  class BadRequest           < StandardError; end
  class NotFound             < StandardError; end
  class NotAcceptable        < StandardError; end
end