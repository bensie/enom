module Enom
  class Domain

    attr_reader :name, :sld, :tld

    def initialize(payload)
      @name      = payload['interface_response']['GetDomainInfo']['domainname']
      @sld, @tld = @name.split('.')
      @domain_payload   = payload
    end

    def lock
    end

    def unlock
    end

    def locked?
      payload = get('Command' => 'GetRegLock', 'SLD' => sld, 'TLD' => tld)
      payload['interface_response']['GetRegLock']['RegLock'] == '1' ? true : false
    end

    def nameservers
      @domain_payload['interface_response']['GetDomainInfo']['configuration']['dns']
    end

    def update_nameservers
    end

    def expiration_date
      @domain_payload['interface_response']['GetDomainInfo']['status']['expiration']
    end

    def expired?
    end

    def registration_status
      @domain_payload['interface_response']['GetDomainInfo']['status']['registrationstatus']
    end

    def renew
    end

  end
end
