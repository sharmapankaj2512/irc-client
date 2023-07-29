require 'minitest/autorun'
require_relative 'irc_client'

class IrcListChannelsTest < Minitest::Test
  def test_list_channels
    client = IrcClient.new("irc.libera.chat", 6667)

    client.register("liberia_test")

    assert client.has_channels
  end
end
