module Enom

  class Error < StandardError
    def initialize(message)
      super "An error occurred: #{message}"
    end
  end

  class InterfaceError < StandardError
    def initialize(message = nil)
      if message
        super message
      else
        super "An unknown error occurred.  Check your username, password, and make sure your IP address is permitted to access the Enom API"
      end
    end
  end

  class NotImplementedError < StandardError
    def initialize
      super "The command you tried is not yet implemented, but we're planning on it!  Feel free to fork the project and contribute!"
    end
  end

  class InvalidNameServerCount < StandardError
    def initialize
      super "A minimum of 2 and maximum of 12 nameservers are required"
    end
  end

end
