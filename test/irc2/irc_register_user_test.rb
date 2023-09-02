require 'minitest/autorun'
require_relative "irc_client"

class IrcRegisterUserTest < Minitest::Test
  def test_user_registration
    client = PersistentIrcClient.new("irc.libera.chat", 6667)
    client.register("random_231")

    assert client.registered
  end
end
