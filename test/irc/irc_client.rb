# frozen_string_literal: true

class IrcClient
  def initialize(host, port)
    @host = host
    @port = port
    @lines = ""
  end

  def connect
    socket = TCPSocket.open(@host, @port)
    while (line = socket.gets) # Read lines from the socket
      @lines += line.chop
    end
    socket.close
  end

  def connected
    @lines.include? "NOTICE"
  end
end
