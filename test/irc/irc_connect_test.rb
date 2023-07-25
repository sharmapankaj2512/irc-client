# frozen_string_literal: true

require_relative 'irc_client.rb'
require "minitest/autorun"
require 'socket'

class IrcConnectTest < Minitest::Test
  def test_connection
    client = IrcClient.new
    response = client.open_connection("irc.libera.chat", 6667)

    assert_includes response, "NOTICE"
  end
end
