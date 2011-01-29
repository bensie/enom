module Enom
  module Commands
    class DescribeDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.find(name)

        puts domain.name.upcase
        puts "Expires: #{domain.expiration_date.strftime("%B %d, %Y")}"

        puts "Name Servers:"
        domain.nameservers.each do |ns|
          puts "\t#{ns}"
        end

        puts "Contact Info:"
        domain.all_contact_info.each do |k,v|
          puts "\t#{k}:"
          v.each do |k,v|
            puts "\t\t#{k}: #{v}"
          end
        end
      end
    end
  end
end
