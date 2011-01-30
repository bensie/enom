require 'yaml'
module Enom

  class CommandNotFound < RuntimeError; end
  class InvalidCredentials < RuntimeError; end

  class CLI

    def initialize
      # If the username and password are set elsewhere, they take precedence
      unless Enom::Client.username && Enom::Client.password
        file = File.expand_path("~/.enomconfig")
        if File.exists?(file)
          credentials = YAML.load(File.new(file))
          Enom::Client.username = credentials['username']
          Enom::Client.password = credentials['password']
        else
          raise InvalidCredentials, "Please provide a username/password as arguments create a config file with credentials in ~/.enomconfig"
        end
      end
    end

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
        'list'     => Enom::Commands::ListDomains,
        'check'    => Enom::Commands::CheckDomain,
        'register' => Enom::Commands::RegisterDomain,
        'renew'    => Enom::Commands::RenewDomain,
        'describe' => Enom::Commands::DescribeDomain
      }
    end

  end
end
require 'enom/commands/list_domains'
require 'enom/commands/check_domain'
require 'enom/commands/register_domain'
require 'enom/commands/renew_domain'
require 'enom/commands/describe_domain'
