require_relative 'two_way_socket'

class PersistentIrcClient
  attr_reader :connected, :registered

  def initialize(host, port)
    @two_way_socket = TwoWaySocket.new(host, port, self)
    @connected = wait_for_connection
  end

  def approve_immediate(response_request)
    is_pong response_request
  end

  def respond_to(response_request)
    server = server_name_from_pong_message(response_request)
    @two_way_socket.send "PONG :#{server}"
  end

  def is_pong(response)
    !response.nil? && response.start_with?("PING")
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
