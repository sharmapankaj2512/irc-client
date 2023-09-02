require "minitest/autorun"
require_relative "irc_client"

class IrcConnectTest < Minitest::Test
  def test_server_connection
    FakeIrcServer.new

    client = PersistentIrcClient.new("localhost", 6667)

    assert client.connected
  end
end

class FakeIrcServer
  def initialize
    @socket = TCPServer.new("localhost", 6667)
    Thread.new do
      loop do
        client = @socket.accept
        client.puts ":localhost NOTICE * :*** Checking Ident"
        client.puts ":localhost NOTICE * :*** Looking up your hostname..."
        client.puts ":localhost NOTICE * :*** Couldn't look up your hostname"
      end
    end
  end
end
