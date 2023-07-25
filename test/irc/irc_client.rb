# frozen_string_literal: true

require "timeout"

class IrcClient
  def initialize(host, port, timeout)
    @host = host
    @port = port
    @timeout = timeout
    @lines = ""
  end

  def connect
    socket = Timeout.timeout(@timeout) do
      TCPSocket.open(@host, @port)
    end
    while (line = socket.gets) # Read lines from the socket
      @lines += line.chop
    end
    socket.close
  end

  def connected
    @lines.include? "NOTICE"
  end
end
