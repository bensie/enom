require 'test_helper'
require File.expand_path('../../lib/enom/cli',   __FILE__)

class CliTest < Test::Unit::TestCase

  context "The CLI command" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
      @cli = Enom::CLI.new
    end

    context "'check'" do
      should "indicate an available domain name is available" do
        assert_equal "test123456test123456.com is available", @cli.execute("check", ["test123456test123456.com"])
      end

      should "indicate an unavailable domain name is unavailable" do
        assert_equal "google.com is unavailable", @cli.execute("check", ["google.com"])
      end
    end

    context "'register'" do
      should "register the domain" do
        assert_equal "Registered test123456test123456.com", @cli.execute("register", ["test123456test123456.com"])
      end
    end

    context "'renew'" do
      should "renew the domain" do
        assert_equal "Renewed test123456test123456.com", @cli.execute("renew", ["test123456test123456.com"])
      end
    end
  end

end
