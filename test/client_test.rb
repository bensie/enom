require "test_helper"

class ClientTest < Test::Unit::TestCase

  context "A test connection" do
    setup do
      Enom::Client.username = "resellidtest"
      Enom::Client.password = "resellpwtest"
      Enom::Client.test = true
    end

    should "return a test Enom::Client object" do
      assert_equal "resellidtest", Enom::Client.username
      assert_equal "resellpwtest", Enom::Client.password
      assert_equal "https://resellertest.enom.com/interface.asp", Enom::Client.base_uri
      assert_equal Hash["UID" => "resellidtest", "PW" => "resellpwtest", "ResponseType" => "xml"], Enom::Client.default_params
    end
  end

  context "A live connection" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
    end

    should "return a real Enom::Client object" do
      assert_equal "resellid", Enom::Client.username
      assert_equal "resellpw", Enom::Client.password
      assert_equal "https://reseller.enom.com/interface.asp", Enom::Client.base_uri
      assert_equal Hash["UID" => "resellid", "PW" => "resellpw", "ResponseType" => "xml"], Enom::Client.default_params
    end
  end

end
