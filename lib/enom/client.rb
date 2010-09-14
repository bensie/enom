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

    def register_domain!(name, options = {})
      sld, tld = name.split('.')
      opts = {}
      if options[:nameservers]
        count = 1
        options[:nameservers].each do |nameserver|
          opts.merge!("NS#{count}" => nameserver)
          count += 1
        end
      end
      opts.merge!('NumYears' => options[:years]) if options[:years]
      purchase = get({'Command' => 'Purchase', 'SLD' => sld, 'TLD' => tld}.merge(opts))
      find_domain(name)
    end

    def get_balance
      get('Command' => 'GetBalance')['interface_response']['AvailableBalance'].gsub(',', '').to_f
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
