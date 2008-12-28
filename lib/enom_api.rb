require 'httpclient'
module EnomApi
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def manage_with_enom
      send :include, InstanceMethods
    end
  end
  
  module InstanceMethods
    @@raw_config = File.read(RAILS_ROOT + "/config/enom_config.yml")
    @@enom_config = YAML.load(@@raw_config)[RAILS_ENV].symbolize_keys
    @@url = @@enom_config[:url]
    @@values = {
      'UID' => @@enom_config[:username],
      'PW' => @@enom_config[:password],
      'ResponseType' => "XML"
    }
    
    def expiration_date
      get_single_item('GetDomainExp', 'ExpirationDate').to_datetime
    end
    
    def nameservers
      get_collection_of_items('GetDNS', 'dns')
    end
    
    def nameservers=(nameservers)    
    end
    
    def registrant_contact
      get_contact_info_for("Registrant")
    end
    
    def registrant_contact=(contact)
      set_contact_info_for("Registrant", contact)
    end
    
    def billing_contact
      get_contact_info_for("Billing")
    end
    
    def billing_contact=(contact)
      set_contact_info_for("Billing", contact)
    end
    
    def technical_contact
      get_contact_info_for("Technical")  
    end
    
    def technical_contact=(contact)
      set_contact_info_for("Technical", contact)
    end
    
    def administrative_contact
      get_contact_info_for("Administrative")
    end
    
    def administrative_contact=(contact)
      set_contact_info_for("Administrative", contact)  
    end
    
    def locked?
      get_single_item('GetRegLock', 'reg-lock') == true
    end
    
    def locked=(locked)
      set_single_item()
    end
    
    private
    
    def get_single_item(enom_command, xml_field_name)
      response = api_call(enom_command)
      REXML::XPath.first(response, "//#{xml_field_name}").text
    end
    
    def get_collection_of_items(enom_command, xml_field_name)
      response = api_call(enom_command)
      items = []
      response.elements.each("interface-response/#{xml_field_name}") { |element| 
        items << element.text
      }
      return items
    end
    
    def get_contact_info_for(contact_type)
      
    end
    
    def set_contact_info_for(contact_type, contact_data)
      
    end
    
    def set_single_item(enom_command)
    
    end
    
    def set_collection_of_items(enom_command)
    
    end
    
    def api_call(enom_command)
      split = name.split('.')
      sld = split.first
      tld = split.last
      values = @@values.merge!({
        'Command' => enom_command,
        'SLD' => sld,
        'TLD' => tld
      })
      REXML::Document.new(HTTPClient.new.get_content(URI.parse(@@url + values.to_query)))
    end
    
    def domain_exists_in_enom_account?
      all_domains = get_collection_of_items('GetAllDomains', 'GetAllDomains/DomainDetail/DomainName')
      unless all_domains.include?(name)
        errors.add_to_base('Domain does not exist in your Enom account.')
      end
    end
  end
end
ActiveRecord::Base.send :include, EnomApi
