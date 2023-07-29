require 'minitest/autorun'
require 'socket'

class IrcConnectionTest < Minitest::Test
  def test_client_not_connected
    client = IrcClient.new

    refute client.connected
  end

  def test_client_connect
    client = IrcClient.new("irc.libera.chat", 6667)

    assert client.connected
  end
end

class IrcClient
  def initialize(host, port)
    @socket = TCPSocket.new(host, port)
    until @socket.eof?
      line = @socket.gets
      @connected = line.include? "NOTICE"
      break if @connected
    end
  end

  def connected
    @connected
  end
end