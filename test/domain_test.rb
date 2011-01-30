require 'test_helper'

class DomainTest < Test::Unit::TestCase

  context "With a valid account" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
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
    end
  end

end
