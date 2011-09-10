#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + "/../lib")
require "enom"
require "enom/cli"

require "optparse"

def usage
  $stderr.puts <<-EOF

This is a command line tool for Enom.

Before using this tool you should create a file called .enomconfig in your home
directory and add the following to that file:

username: YOUR_USERNAME
password: YOUR_PASSWORD

Alternatively you can pass the credentials via command-line arguments, as in:

enom -u username -p password command

You can run commands from the test interface with the -t flag:
enom -u username -p password -t command

== Commands

All commands are executed as enom [options] command [command-options] args


The following commands are available:

help                                    # Show this usage

list                                    # List all domains
check domain.com                        # Check if a domain is available (for registration)
describe domain.com                     # Describe a domain
register domain.com                     # Register a domain with Enom
renew domain.com                        # Renew a domain with Enom
transfer domain.com 867e5926e93         # Transfer a domain to Enom (requires auth/EPP code)

EOF
end

options = {}

global = OptionParser.new do |opts|
  opts.on("-u", "--username [ARG]") do |username|
    Enom::Client.username = username
  end
  opts.on("-p", "--password [ARG]") do |password|
    Enom::Client.password = password
  end
  opts.on("-t") do
    Enom::Client.test = true
  end
end

global.order!
command = ARGV.shift

if command.nil? || command == "help"
  usage
else
  begin
    cli = Enom::CLI.new
    cli.execute(command, ARGV, options)
  rescue Enom::CommandNotFound => e
    puts e.message
  rescue Enom::InvalidCredentials => e
    puts e.message
  rescue Enom::InterfaceError => e
    puts e.message
  end
end
