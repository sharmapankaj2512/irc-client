require 'minitest/autorun'
require 'socket'
require 'timeout'

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

class IrcClient
  def initialize(host, port)
    begin
      connect(host, port)
    rescue SocketError
      @connected = false
    rescue Timeout::Error
      @connected = false
    end
  end

  def connected
    @connected
  end

  private

  def connect(host, port)
    @socket = Timeout::timeout(10) do
      TCPSocket.new(host, port)
    end
    until @socket.eof?
      line = @socket.gets
      @connected = line.include? "NOTICE"
      break if @connected
    end
  end
end