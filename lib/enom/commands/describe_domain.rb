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
          puts "\s\s#{ns}"
        end

        puts "Contact Info:"
        domain.all_contact_info.each do |k,v|
          puts "\s\s#{k}:"
          v.each do |kk,vv|
            puts "\s\s\s\s#{kk.gsub(k, '')}: #{vv}"
          end
        end
      end
    end
  end
end
