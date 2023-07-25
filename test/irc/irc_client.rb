class IrcClient
  def open_connection(host, port)
    socket = TCPSocket.open(host, port)
    lines = ""
    while (line = socket.gets) # Read lines from the socket
      lines += line.chop
    end
    socket.close
    lines
  end
end
