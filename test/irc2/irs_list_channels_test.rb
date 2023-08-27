require 'minitest/autorun'
require_relative "irc_client"

class IrsListChannelsTest < Minitest::Test
  def test_channels
    client = IrcClientAsync.new("irc.libera.chat", 6667)
    client.register("random_231_324")

    assert client.has_channels
  end
end
