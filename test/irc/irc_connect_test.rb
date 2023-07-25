# frozen_string_literal: true

require_relative 'irc_client'
require "minitest/autorun"
require 'socket'

class IrcConnectTest < Minitest::Test
  def test_connection
    client = IrcClient.new("irc.libera.chat", 6667)
    response = client.connect

    assert_includes response, "NOTICE"
  end
end
