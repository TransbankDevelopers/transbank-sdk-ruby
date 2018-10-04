require 'uri'
require 'net/http'
require 'json'


module Transbank
  module Onepay
    module Utils
      # TODO: Document
      module NetHelper
        def http_post(uri_string, body)
          uri = URI.parse(uri_string)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          request = Net::HTTP::Post.new(uri.path, 'Content-Type'=> 'application/json')
          request.body = JSON.generate(body)
          result = http.request(request)
          JSON.parse(result.body)
        end
      end
    end
  end
end
