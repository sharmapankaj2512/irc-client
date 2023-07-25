# frozen_string_literal: true

class IrcClient
  def initialize(host, port)
    @host = host
    @port = port
  end

  def connect
    socket = TCPSocket.open(@host, @port)
    lines = ""
    while (line = socket.gets) # Read lines from the socket
      lines += line.chop
    end
    socket.close
    lines
  end
end
