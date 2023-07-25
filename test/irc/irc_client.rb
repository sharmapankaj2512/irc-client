# frozen_string_literal: true

require "timeout"

class IrcClient
  def initialize(host, port)
    @host = host
    @port = port
    @lines = ""
  end

  def connect
    socket = Timeout.timeout(300) do
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
