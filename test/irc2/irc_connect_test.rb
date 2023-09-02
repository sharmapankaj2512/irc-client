require "minitest/autorun"
require_relative "irc_client"
require 'singleton'

class IrcConnectTest < Minitest::Test
  def test_server_connection
    FakeIrcServer.instance

    client = PersistentIrcClient.new("localhost", 6667)

    assert client.connected
  end
end

class FakeIrcServer
  include Singleton

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
