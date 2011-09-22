module Enom

  class Domain
    include HTTParty
    include ContactInfo

    # The domain name on Enom
    attr_reader :name

    # Second-level and first-level domain on Enom
    attr_reader :sld, :tld

    # Domain expiration date (currently returns a string - 11/9/2010 11:57:39 AM)
    attr_reader :expiration_date


    def initialize(attributes)
      @name = attributes["DomainName"] || attributes["domainname"]
      @sld, @tld = @name.split(".")

      expiration_date_string = attributes["expiration_date"] || attributes["status"]["expiration"]
      @expiration_date = Date.strptime(expiration_date_string.split(" ").first, "%m/%d/%Y")

      # If we have more attributes for the domain from running GetDomainInfo
      # (as opposed to GetAllDomains), we should save it to the instance to
      # save on future API calls
      if attributes["services"] && attributes["status"]
        set_extended_domain_attributes(attributes)
      end
    end

    # Find the domain (must be in your account) on Enom
    def self.find(name)
      sld, tld = name.split(".")
      response = Client.request("Command" => "GetDomainInfo", "SLD" => sld, "TLD" => tld)["interface_response"]["GetDomainInfo"]
      Domain.new(response)
    end

    # Determine if the domain is available for purchase
    def self.check(name)
      available?(name) ? "available" : "unavailable"
    end

    # Boolean helper method to determine if the domain is available for purchase
    def self.available?(name)
      sld, tld = name.split(".")
      response = Client.request("Command" => "Check", "SLD" => sld, "TLD" => tld)["interface_response"]["RRPCode"]
      response == "210"
    end

    # Determine if a list of domains are available for purchase
    # Returns an array of available domain names given

    # Default TLD check lists
    # *   com, net, org, info, biz, us, ws, cc, tv, bz, nu
    # *1  com, net, org, info, biz, us, ws
    # *2  com, net, org, info, biz, us
    # @   com, net, org

    # You can provide one of the default check lists or provide an array of strings
    # to check a custom set of TLDs. Enom currently chokes when specifying a custom
    # list, so this will raise a NotImplementedError until Enom fixes this
    def self.check_multiple_tlds(sld, tlds = "*")
      if tlds.kind_of?(Array)
        # list = tlds.join(",")
        # tld  = nil
        raise NotImplementedError
      elsif %w(* *1 *2 @).include?(tlds)
        list = nil
        tld  = tlds
      end

      response = Client.request("Command" => "Check", "SLD" => sld, "TLD" => tld, "TLDList" => list)

      result = []
      response["interface_response"].each do |k, v|
        if v == "210" #&& k[0,6] == "RRPCode"
          pos = k[7..k.size]
          result << response["interface_response"]["Domain#{pos}"] unless k.blank?
        end
      end

      return result
    end

    # Find and return all domains in the account
    def self.all(options = {})
      response = Client.request("Command" => "GetAllDomains")["interface_response"]["GetAllDomains"]["DomainDetail"]

      domains = []
      response.each {|d| domains << Domain.new(d) }
      return domains
    end

    # Purchase the domain
    def self.register!(name, options = {})
      sld, tld = name.split(".")
      opts = {}
      if options[:nameservers]
        count = 1
        options[:nameservers].each do |nameserver|
          opts.merge!("NS#{count}" => nameserver)
          count += 1
        end
      else
        opts.merge!("UseDNS" => "default")
      end
      opts.merge!("NumYears" => options[:years]) if options[:years]
      response = Client.request({"Command" => "Purchase", "SLD" => sld, "TLD" => tld}.merge(opts))
      Domain.find(name)
    end


    # Transfer domain from another registrar to Enom, charges the account when successful
    # Returns true if successful, false if failed
    def self.transfer!(name, auth, options = {})
      sld, tld = name.split(".")

      # Default options
      opts = {
        "OrderType"   => "AutoVerification",
        "DomainCount" => 1,
        "SLD1"        => sld,
        "TLD1"        => tld,
        "AuthInfo1"   => auth, # Authorization (EPP) key from the
        "UseContacts" => 1     # Set UseContacts=1 to transfer existing Whois contacts with a domain that does not require extended attributes.
      }

      opts.merge!("Renew" => 1) if options[:renew]

      response = Client.request({"Command" => "TP_CreateOrder"}.merge(opts))["ErrCount"]

      response.to_i == 0
    end


    # Renew the domain
    def self.renew!(name, options = {})
      sld, tld = name.split(".")
      opts = {}
      opts.merge!("NumYears" => options[:years]) if options[:years]
      response = Client.request({"Command" => "Extend", "SLD" => sld, "TLD" => tld}.merge(opts))
      Domain.find(name)
    end

    # Suggest available domains using the namespinner
    # Returns an array of available domain names that match
    def self.suggest(name, options ={})
      sld, tld = name.split(".")
      opts = {}
      opts.merge!("MaxResults" => options[:max_results] || 8, "Similar" => options[:similar] || "High")
      response = Client.request({"Command" => "namespinner", "SLD" => sld, "TLD" => tld}.merge(opts))
      
      suggestions = []
      response["interface_response"]["namespin"]["domains"]["domain"].map do |d|
        (options[:tlds] || %w(com net tv cc)).each do |toplevel|
          suggestions << [d["name"].downcase, toplevel].join(".") if d[toplevel] == "y"
        end
      end
      return suggestions
    end

    # Lock the domain at the registrar so it can"t be transferred
    def lock
      Client.request("Command" => "SetRegLock", "SLD" => sld, "TLD" => tld, "UnlockRegistrar" => "0")
      @locked = true
      return self
    end

    # Unlock the domain at the registrar to permit transfers
    def unlock
      Client.request("Command" => "SetRegLock", "SLD" => sld, "TLD" => tld, "UnlockRegistrar" => "1")
      @locked = false
      return self
    end

    # Check if the domain is currently locked.  locked? helper method also available
    def locked
      unless defined?(@locked)
        response = Client.request("Command" => "GetRegLock", "SLD" => sld, "TLD" => tld)["interface_response"]["reg_lock"]
        @locked = response == "1"
      end
      return @locked
    end
    alias_method :locked?, :locked

    # Check if the domain is currently unlocked.  unlocked? helper method also available
    def unlocked
      !locked?
    end
    alias_method :unlocked?, :unlocked

    # Return the DNS nameservers that are currently used for the domain
    def nameservers
      get_extended_domain_attributes unless @nameservers
      return @nameservers
    end

    def update_nameservers(nameservers = [])
      count = 1
      ns = {}
      if (2..12).include?(nameservers.size)
        nameservers.each do |nameserver|
          ns.merge!("NS#{count}" => nameserver)
          count += 1
        end
        Client.request({"Command" => "ModifyNS", "SLD" => sld, "TLD" => tld}.merge(ns))
        @nameservers = ns.values
        return self
      else
        raise InvalidNameServerCount
      end
    end

    def expiration_date
      unless defined?(@expiration_date)
        date_string = @domain_payload["interface_response"]["GetDomainInfo"]["status"]["expiration"]
        @expiration_date = Date.strptime(date_string.split(" ").first, "%m/%d/%Y")
      end
      @expiration_date
    end

    def registration_status
      get_extended_domain_attributes unless @registration_status
      return @registration_status
    end

    def active?
      registration_status == "Registered"
    end

    def expired?
      registration_status == "Expired"
    end

    def renew!(options = {})
      Domain.renew!(name, options)
    end
    
    def set_hosts(hosts, include_www = false) 
      std_opts = {'Command' => 'SetHosts', 'SLD' => self.sld, 'TLD' => self.tld}
      hosts.each_with_index do |host, index|
        std_opts.merge!({"Address#{index + 1}" => host, "HostName#{index + 1}" => self.name,  "RecordType#{index + 1}" => "A"})
        if include_www
          std_opts.merge!({"Address#{index + hosts.size + 1}" => "hosting.realpractice.com", "HostName#{index + hosts.size + 1}" => "www.#{self.name}",  "RecordType#{index + hosts.size + 1}" => "CNAME"})
        end
      end
      response = Client.request(std_opts)["interface_response"]
      response["Done"] =~ /true/i && response["ErrCount"] == "0"
    end

    private

    # Make another API call to get all domain info. Often necessary when domains are
    # found using Domain.all instead of Domain.find.
    def get_extended_domain_attributes
      sld, tld = name.split(".")
      attributes = Client.request("Command" => "GetDomainInfo", "SLD" => sld, "TLD" => tld)["interface_response"]["GetDomainInfo"]
      set_extended_domain_attributes(attributes)
    end

    # Set any more attributes that we have to work with to instance variables
    def set_extended_domain_attributes(attributes)
      @nameservers = attributes["services"]["entry"].first["configuration"]["dns"]
      @registration_status = attributes["status"]["registrationstatus"]
      return self
    end

  end
end
