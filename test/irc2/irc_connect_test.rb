require "minitest/autorun"
require_relative "irc_client"

class IrcConnectTest < Minitest::Test
  def test_server_connection
    client = IrcClientAsync.new("irc.libera.chat", 6667)

    assert client.connected
  end
end
