# frozen_string_literal: true

require_relative "irc_client"
require "minitest/autorun"

class IrcRegisterTest < Minitest::Test
  def test_register_connection
    client = IrcClient.new("irc.libera.chat", 6667, 300)
    client.connect
    client.register("Full Name", "nickname")

    assert client.registered
  end
end
