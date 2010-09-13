require 'cgi'
module Enom

  class Client

    def initialize(username, password, ssl = true, test = false)
      @@username = username
      @@password = password
      @@protocol = ssl == true ? "https" : "http"
      @@endpoint = test == true ? "resellertest.enom.com" : "reseller.enom.com"
    end

    def find_domain(name)
      payload = get('Command' => 'GetDomainInfo', 'SLD' => name.split('.').first, 'TLD' => name.split('.').last)
      Domain.new(payload)
    end

    private

    def get(params = {})
      params.merge!(default_params)
      payload = Crack::XML.parse(RestClient.get(url, {:params => params }))
      raise InterfaceError unless payload['interface_response']['ErrCount'] == '0'
    end

    def url
      @@protocol + "://" + @@endpoint + "/interface.asp"
    end

    def default_params
      { 'UID' => @@username, 'PW' => @@password, 'ResponseType' => 'xml'}
    end

  end
end
