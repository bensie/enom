module Enom
  module Commands
    class RegisterDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.renew!(name)
        puts "Renewed #{domain.name}"
      end
    end
  end
end
