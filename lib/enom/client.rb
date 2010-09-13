require 'cgi'
module Enom

  class Client

    def initialize(username, password, test = false, ssl = false)
      @@username = username
      @@password = password
      @@protocol = ssl == true ? "https" : "http"
      @@endpoint = test == true ? "resellertest.enom.com" : "reseller.enom.com"
    end

    def find_domain(name)
      get('Command' => 'GetDomainInfo', 'SLD' => name.split('.').first, 'TLD' => name.split('.').last)
    end

    private

    def get(params = {})
      params.merge!(default_params)
      Crack::XML.parse(RestClient.get(url, {:params => params }))
    end

    def url
      @@protocol + "://" + @@endpoint + "/interface.asp"
    end

    def default_params
      { 'UID' => @@username, 'PW' => @@password, 'ResponseType' => 'xml'}
    end

  end
end
