require 'minitest/autorun'
require_relative 'irc_client'

class IrcKeepConnectionAliveTest < Minitest::Test
  def test_test
    client = IrcClient.new("irc.libera.chat", 6667)

    client.register("liberia_test")
    sleep 300

    assert client.has_channels
  end
end
