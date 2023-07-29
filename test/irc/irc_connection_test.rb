require 'minitest/autorun'

class IrcConnectionTest < Minitest::Test
  def test_client_connects
    client = IrcClient.new

    refute client.connected
  end
end

class IrcClient
  def connected
    # code here
  end
end