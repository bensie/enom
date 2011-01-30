module Enom
  module Commands
    class CheckDomain
      def execute(args, options={})
        name = args.shift
        response = Domain.check(name)
        output = "#{name} is #{response}"
        puts output
        return output
      end
    end
  end
end
