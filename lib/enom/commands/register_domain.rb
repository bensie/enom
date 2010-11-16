module Enom
  module Commands
    class RegisterDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.register!(name)
        puts "Registered #{domain.name}"
      end
    end
  end
end
