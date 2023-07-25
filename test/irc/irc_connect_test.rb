# frozen_string_literal: true

require_relative "irc_client"
require "minitest/autorun"
require "socket"

class IrcConnectTest < Minitest::Test
  def test_successful_connection
    client = IrcClient.new("irc.libera.chat", 6667, 300)
    client.connect

    assert client.connected
  end

  def test_no_connection_for_invalid_port
    client = IrcClient.new("irc.libera.chat", 666, 10)
    client.connect

    refute(client.connected)
  end
end
