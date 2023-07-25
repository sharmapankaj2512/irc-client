# frozen_string_literal: true

require_relative "irc_client"
require "minitest/autorun"
require "socket"

class IrcConnectTest < Minitest::Test
  def test_successful_connection
    client = IrcClient.new("irc.libera.chat", 6667)
    client.connect

    assert client.connected
  end
end
