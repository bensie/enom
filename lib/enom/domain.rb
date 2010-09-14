module Enom
  class Domain < Client

    attr_reader :name, :sld, :tld

    def initialize(payload)
      @name           = payload['interface_response']['GetDomainInfo']['domainname']
      @sld, @tld      = @name.split('.')
      @domain_payload = payload
    end

    def lock
      get('Command' => 'SetRegLock', 'SLD' => sld, 'TLD' => tld, 'UnlockRegistrar' => '0')
      return nil
    end

    def unlock
      get('Command' => 'SetRegLock', 'SLD' => sld, 'TLD' => tld, 'UnlockRegistrar' => '1')
      return nil
    end

    def locked?
      payload = get('Command' => 'GetRegLock', 'SLD' => sld, 'TLD' => tld)
      payload['interface_response']['reg_lock'] == '1' ? true : false
    end

    def nameservers
      @domain_payload['interface_response']['GetDomainInfo']['services']['entry'].first['configuration']['dns']
    end

    def update_nameservers(nameservers)
      count = 1
      ns = {}
      if (2..12).include?(nameservers.size)
        nameservers.each do |nameserver|
          ns.merge!("NS#{count}" => nameserver)
          count += 1
        end
        get({'Command' => 'ModifyNS', 'SLD' => sld, 'TLD' => tld}.merge(ns))
        return nil
      else
        raise InvalidNameServerCount, "A minimum of 2 and maximum of 12 nameservers are required"
      end
    end

    def expiration_date
      date_string = @domain_payload['interface_response']['GetDomainInfo']['status']['expiration']
      Date.parse(date_string.split(' ').first)
    end

    def expired?
      registration_status == 'Expired'
    end

    def registration_status
      @domain_payload['interface_response']['GetDomainInfo']['status']['registrationstatus']
    end

    def renew!(years = 1)
      # get('Command' => 'Renew', 'SLD' => sld, 'TLD' => tld)
      raise NotImplementedError
    end

  end
end
