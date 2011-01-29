module Enom
  module ContactInfo

    CONTACT_TYPES = %w(Registrant AuxBilling Tech Admin)
    FIELDS = [
      {:name => "FirstName",            :required => true},
      {:name => "LastName",             :required => true},
      {:name => "OrganizationName",     :required => true},
      {:name => "JobTitle",             :required => false},
      {:name => "Address1",             :required => true},
      {:name => "Address2",             :required => false},
      {:name => "City",                 :required => true},
      {:name => "StateProvinceChoice",  :required => false}, # "S" or "P" are valid
      {:name => "StateProvince",        :required => false},
      {:name => "PostalCode",           :required => true},
      {:name => "Country",              :required => true},
      {:name => "EmailAddress",         :required => true},
      {:name => "Phone",                :required => true}
    ]

    CONTACT_TYPES.each do |contact_type|

      # Define getter methods for each contact type
      # def registrant_contact_info
      # ...
      # end
      define_method "#{contact_type.downcase}_contact_info" do
        response = Client.request({'Command' => 'GetContacts', 'SLD' => sld, 'TLD' => tld}.merge(opts))["interface_response"]["GetContacts"][contact_type]
      end

      # Define setter methods for each contact type
      # def update_registrant_contact_info
      # ...
      # end
      define_method "update_#{contact_type.downcase}_contact_info" do |contact_data = {}|

        # Remove attributes that are not in Enom's list of available fields
        contact_data.select!{|k| FIELDS.map{|f| f[:name] }.include?(k)}

        # Write the initial options hash containing the current ContactType
        opts = {"ContactType" => contact_type}

        # Check to make sure all required fields are present
        FIELDS.each do |field|
          if field[:required]
            if contact_data[field[:name]].nil? || contact_data[field[:name]].empty?
              raise Error, "#{field[:name]} is required to update contact info"
            end
          end
        end

        # Prepend ContactType to beginning of all data and add to options hash
        contact_data.each do |k,v|
          opts.merge!("#{contact_type}#{k}" => v)
        end

        response = Client.request({'Command' => 'Contacts', 'SLD' => sld, 'TLD' => tld}.merge(opts))["interface_response"]
        return response["Done"] == "true"
      end

      # Update all contact types with the same data
      # Performs a separate API call for each type
      def update_all_contact_info(data = {})
        CONTACT_TYPES.each do |contact_type|
          send("update_#{contact_type.downcase}_contact_info", data)
        end
      end

    end

  end
end
