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
      sld, tld = name.split('.')
      payload = get('Command' => 'GetDomainInfo', 'SLD' => sld, 'TLD' => tld)
      Domain.new(payload)
    end

    def get_balance
      get('Command' => 'GetBalance')
    end

    private

    def get(params = {})
      params.merge!(default_params)
      payload = Crack::XML.parse(RestClient.get(url, {:params => params }))
      if payload['interface_response']['ErrCount'] == '0'
        return payload
      else
        raise InterfaceError
      end
    end

    def url
      @@protocol + "://" + @@endpoint + "/interface.asp"
    end

    def default_params
      { 'UID' => @@username, 'PW' => @@password, 'ResponseType' => 'xml'}
    end

  end
end
