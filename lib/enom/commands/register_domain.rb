module Enom
  module Commands
    class RegisterDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.register!(name)
        output = "Registered #{domain.name}"
        puts output
        return output
      end
    end
  end
end
