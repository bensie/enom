#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'enom'
require 'enom/cli'

cli = Enom::CLI.new

require 'optparse'
require 'yaml'

def usage
  $stderr.puts <<-EOF

This is a command line tool for Enom.

Before using this tool you should create a file called .enom in your home
directory and add the following to that file:

username: YOUR_USERNAME
password: YOUR_PASSWORD

Alternatively you can pass the credentials via command-line arguments, as in:

enom -u username -p password command

== Commands

All commands are executed as enom [options] command [command-options] args


The following commands are available:

help                                    # Show this usage
info                                    # Show your account information

list                                    # List all domains

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

if command.nil? || command == 'help'
  usage
else
  unless Enom::Client.username && Enom::Client.password
    if File.exists?("~/.enomconfig")
      credentials = YAML.load(File.new(File.expand_path('~/.enomconfig')))
      Enom::Client.username = credentials['username']
      Enom::Client.password = credentials['password']
    else
      raise RuntimeError, "Please provide a username/password as arguments create a config file with credentials in ~/.enomconfig"
    end
  end

  begin
    cli.execute(command, ARGV, options)
  rescue Enom::CommandNotFound => e
    puts e.message
  end

end
