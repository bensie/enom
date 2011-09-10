require "test_helper"

class ContactInfoTest < Test::Unit::TestCase

  context "A domain in your account" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
      @domain = Enom::Domain.find("test123456test123456.com")
    end

    should "respond to included contact methods" do
      Enom::ContactInfo::CONTACT_TYPES.each do |contact_type|
        assert_respond_to @domain, "#{contact_type.downcase}_contact_info"
        assert_respond_to @domain, "update_#{contact_type.downcase}_contact_info"
      end
      assert_respond_to @domain, :all_contact_info
      assert_respond_to @domain, :update_all_contact_info
    end
  end

end
