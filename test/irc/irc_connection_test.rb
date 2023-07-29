require 'minitest/autorun'

class IrcConnectionTest < Minitest::Test
  def test_client_connect
    client = IrcClient.new("irc.libera.chat", 6667)

    assert client.connected
  end

  def test_invalid_port
    client = IrcClient.new("irc.libera.chat", 666)

    refute client.connected
  end

  def test_invalid_host
    client = IrcClient.new("irc.libera123.test", 6667)

    refute client.connected
  end
end

require_relative 'irc_client.rb'
