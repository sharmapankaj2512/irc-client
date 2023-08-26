require "minitest/autorun"
require_relative "irc_client"

class IrcKeepConnectionAliveTest < Minitest::Test
  def test_stay_alive
    client = IrcClientAsync.new("irc.libera.chat", 6667)
    client.register("random_231123")

    sleep(to_seconds(minutes(5)))

    assert client.has_channels
  end

  private

  def to_seconds(minutes)
    minutes * 60
  end

  def minutes(integer)
    integer
  end
end
