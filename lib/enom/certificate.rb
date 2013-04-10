require "public_suffix"

module Enom

  class Certificate
    include HTTParty
    include ContactInfo

    def initialize(attributes)

    end
    
    def self.get_certs(options = {})
      response = Client.request("Command" => "GetCerts")["interface_response"]["GetCerts"]["Certs"]
      response = [response] unless response.is_a?(Array)

      certs = []
      response.each {|c| certs << Certificate.new(c) }
      return certs
    end
  end
end
