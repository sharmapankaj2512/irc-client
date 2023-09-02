require "minitest/autorun"
require 'singleton'
require_relative "irc_client"
require_relative "fake_irc_server"

class IrcConnectTest < Minitest::Test
  def test_server_connection
    FakeIrcServer.instance

    client = PersistentIrcClient.new("localhost", 6667)

    assert client.connected
  end
end

