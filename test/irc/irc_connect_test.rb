# frozen_string_literal: true

require "minitest/autorun"
require 'socket'

class IrcConnectTest < Minitest::Test
  def open_connection(host, port)
    socket = TCPSocket.open(host, port)
    lines = ""
    while (line = socket.gets)     # Read lines from the socket
      lines += line.chop
    end
    socket.close
    lines
  end

  def test_connection
    response = open_connection("irc.libera.chat", 6667)

    assert_includes response, "NOTICE"
  end
end
