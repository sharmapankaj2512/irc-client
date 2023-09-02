require_relative 'two_way_socket'

class PersistentIrcClient
  attr_reader :connected, :registered

  def initialize(host, port)
    @two_way_socket = TwoWaySocket.new(host, port)
    @connected = wait_for_connection
  end

  def wait_for_connection
    @two_way_socket.listen_for("NOTICE")
  end

  def register(nickname)
    message = "NICK #{nickname}\nUSER #{nickname} 0 * : #{nickname}"
    @two_way_socket.send(message)
    @registered = @two_way_socket.listen_for(":End of /MOTD command")
  end

  def has_channels
    @two_way_socket.send("LIST")
    @two_way_socket.listen_for ":End of /LIST"
  end

  private

  def server_name_from_pong_message(line)
    line.split(":").last
  end
end
