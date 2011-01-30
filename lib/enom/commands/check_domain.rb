module Enom
  module Commands
    class CheckDomain
      def execute(args, options={})
        name = args.shift
        response = Domain.check(name)
        puts "#{name} is #{response}"
      end
    end
  end
end
