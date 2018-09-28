require 'uri'
require 'net/http'
require 'json'
# TODO: Document
class NetHelper
  class << self
    def post(uri_string, body)
      uri = URI.parse(uri_string)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP.post(uri.path, 'Content-Type': 'application/json')
      request.body = body.jsonify
      result = http.request(request)
      JSON.parse(result)
    end
  end
end