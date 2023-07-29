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
end

class IrcClient
  def initialize(host, port)
    begin
      @socket = connect(host, port)
      until @socket.eof?
        line = @socket.gets
        @connected = line.include? "NOTICE"
        break if @connected
      end
    rescue Timeout::Error
      @connected = false
    end
  end

  def connected
    @connected
  end

  private

  def connect(host, port)
    Timeout::timeout(10) do
      TCPSocket.new(host, port)
    end
  end
end