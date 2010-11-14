module Enom

  class CommandNotFound < RuntimeError; end

  class CLI

    def execute(command_name, args, options={})
      command = commands[command_name]
      if command
        begin
          command.new.execute(args, options)
        rescue Enom::Error => e
          puts "An error occurred: #{e.message}"
        rescue RuntimeError => e
          puts "An error occurred: #{e.message}"
        end
      else
        raise CommandNotFound, "Unknown command: #{command_name}"
      end
    end

    def commands
      {
        'list' => Enom::Commands::ListDomains
      }
    end

  end
end
require 'enom/commands/list_domains'
