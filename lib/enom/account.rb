module Enom
  class Account

    def self.balance
      Client.request('Command' => 'GetBalance')['interface_response']['AvailableBalance'].gsub(',', '').to_f
    end

  end
end