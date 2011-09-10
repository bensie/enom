require 'test_helper'

class DomainTest < Test::Unit::TestCase

  context "With a valid account" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
    end

    context "listing all domains" do
      setup do
        @domains = Enom::Domain.all
      end
      should "return several domain objects" do
        @domains.each do |domain|
          assert_kind_of Enom::Domain, domain
        end
      end
      should "return two domains" do
        assert_equal 2, @domains.size
      end
    end

    context "checking for available domains" do
      should "return 'available' for an available domain" do
        assert_equal "available", Enom::Domain.check("test123456test123456.com")
        assert Enom::Domain.available?("test123456test123456.com")
      end
      should "return 'unavailable' for an unavailable domain" do
        assert_equal "unavailable", Enom::Domain.check("google.com")
        assert !Enom::Domain.available?("google.com")
      end
    end

    context "checking multiple TLDs for a single domain" do
      should "return an array of available domains with the provided TLD" do
        wildcard_tld_domains = %w(
          test123456test123456.com
          test123456test123456.net
          test123456test123456.org
          test123456test123456.info
          test123456test123456.biz
          test123456test123456.ws
          test123456test123456.us
          test123456test123456.cc
          test123456test123456.tv
          test123456test123456.bz
          test123456test123456.nu
          test123456test123456.mobi
          test123456test123456.eu
          test123456test123456.ca
        )
        assert_equal wildcard_tld_domains, Enom::Domain.check_multiple_tlds("test123456test123456","*")
        assert_equal ["test123456test123456.us", "test123456test123456.ca", "test123456test123456.com"], Enom::Domain.check_multiple_tlds("test123456test123456", ["us", "ca", "com"])
      end
    end

    context "registering a domain" do
      setup do
        @domain = Enom::Domain.register!("test123456test123456.com")
      end
      should "register the domain and return a domain object" do
        assert_kind_of Enom::Domain, @domain
        assert_equal @domain.name, "test123456test123456.com"
      end
    end

    context "transfer a domain" do
      setup do
        @result = Enom::Domain.transfer!("resellerdocs2.net", "ros8enQi")
      end
      should "transfer the domain and return true if successful" do
        assert @result
      end
    end

    context "renewing a domain" do
      setup do
        @domain = Enom::Domain.renew!("test123456test123456.com")
      end
      should "renew the domain and return a domain object" do
        assert_kind_of Enom::Domain, @domain
        assert_equal @domain.name, "test123456test123456.com"
      end
    end

    context "finding a domain in your account" do
      setup do
        @domain = Enom::Domain.find("test123456test123456.com")
      end

      should "return a domain object" do
        assert_kind_of Enom::Domain, @domain
      end

      should "have corect attributes" do
        assert_equal "test123456test123456.com", @domain.name
        assert_equal "test123456test123456", @domain.sld
        assert_equal "com", @domain.tld
      end

      should "be registered" do
        assert @domain.active?
        assert !@domain.expired?
      end

      should "be locked" do
        assert @domain.locked?
        assert !@domain.unlocked?
      end

      context "with default nameservers" do
        should "have default Enom nameservers" do
          nameservers = [
            "dns1.name-services.com",
            "dns2.name-services.com",
            "dns3.name-services.com",
            "dns4.name-services.com",
            "dns5.name-services.com"
          ]
          assert_equal nameservers, @domain.nameservers
        end
        should "update nameservers if there are 2 or more provided" do
          new_nameservers = ["ns1.foo.com", "ns2.foo.com"]
          @domain.update_nameservers(new_nameservers)
          assert_equal new_nameservers, @domain.nameservers
        end
        should "not update nameservers if less than 2 or more than 12 are provided" do
          not_enough = ["ns1.foo.com"]
          too_many = ["ns1.foo.com", "ns2.foo.com", "ns3.foo.com", "ns4.foo.com", "ns5.foo.com", "ns6.foo.com", "ns7.foo.com", "ns8.foo.com", "ns9.foo.com", "ns10.foo.com", "ns11.foo.com", "ns12.foo.com", "ns13.foo.com"]
          assert_raises Enom::InvalidNameServerCount do
            @domain.update_nameservers(not_enough)
          end
          assert_raises Enom::InvalidNameServerCount do
            @domain.update_nameservers(too_many)
          end
        end
      end

      should "have an expiration date" do
        assert_kind_of Date, @domain.expiration_date
        assert_equal "2012-01-30", @domain.expiration_date.strftime("%Y-%m-%d")
      end

      context "that is currently locked" do
        setup do
          @domain.unlock
        end

        should "unlock successfully" do
          assert !@domain.locked?
          assert @domain.unlocked?
        end
      end
    end
  end

end
