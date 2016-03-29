module NativeSyncCli
  module Util

    autoload :RestClient,    'rest-client'
    autoload :JSON,          'json'
    autoload :URI,           'uri'

    ## Internal methods
    # Rest Call
    def self.rest(method, endpoint, payload=nil, api_key=nil)
      full_url = URI.join("https://api.nativesync.io", "/v1#{endpoint}").to_s
      full_url = URI.join("https://4c949tv2j6.execute-api.us-west-2.amazonaws.com", "/prod/v1#{endpoint}").to_s

      begin
        # we only post to NS
        response = RestClient.post full_url, payload.to_json,  :content_type => :json, :accept => :json
        puts "\n"
        JSON.parse(response)
      rescue SocketError => e
        raise "Could not find the NativeSync server."

      rescue RestClient::BadGateway => e
        raise "Could not contact the NativeSync server."
      rescue JSON::ParserError => e
        raise response.to_s
      rescue Exception => e
        raise e
      end
    end

    def self.numeric?(string)
      Float(string) != nil rescue false
    end
  end
end
