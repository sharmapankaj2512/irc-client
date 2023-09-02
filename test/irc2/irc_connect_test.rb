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

  def handle_client(client)
    welcome_messages(client)
  end

  def initialize
    @socket = TCPServer.new("localhost", 6667)
    Thread.new do
      loop do
        handle_client(@socket.accept)
      end
    end
  end

  private

  def welcome_messages(client)
    client.puts ":localhost NOTICE * :*** Checking Ident"
    client.puts ":localhost NOTICE * :*** Looking up your hostname..."
    client.puts ":localhost NOTICE * :*** Couldn't look up your hostname"
  end
end
