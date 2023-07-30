require "minitest/autorun"

class IrcConnectTest < Minitest::Test
  def test_server_connection
    client = IrcClientAsync.new("irc.libera.chat", 6667)

    assert client.connected
  end
end

require "socket"

class IrcClientAsync
  attr_reader :connected

  def initialize(host, port)
    @server_replies = Queue.new
    @socket = TCPSocket.new(host, port)
    read_write_loop
    @connected = wait_for_connection
  end

  def read_write_loop
    Thread.new do
      while (line = @socket.gets)
        @server_replies.push(line)
      end
    end
  end

  def wait_for_connection
    lines = ""
    lines += @server_replies.pop
    lines += @server_replies.pop
    lines += @server_replies.pop
    lines.include? "NOTICE"
  end
end
