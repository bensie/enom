require 'test_helper'

class DomainTest < Test::Unit::TestCase

  context "With a valid account" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
    end

    context "checking for available domains" do
      should "return 'available' for an available domain" do
        assert_equal "available", Enom::Domain.check("test123456test123456.com")
      end
      should "return 'unavailable' for an unavailable domain" do
        assert_equal "unavailable", Enom::Domain.check("google.com")
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
