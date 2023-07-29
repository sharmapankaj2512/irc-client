require 'minitest/autorun'
require_relative 'irc_client'

class IrcRegisterUserTest < Minitest::Test
  def test_register_user
    client = IrcClient.new("irc.libera.chat", 6667)
    client.register("nickname")

    assert client.registered
  end
end
