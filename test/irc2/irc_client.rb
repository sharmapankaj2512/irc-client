require_relative 'two_way_socket'
class IrcClientAsync
  attr_reader :connected, :registered

  def initialize(host, port)
    @two_way_socket = TwoWaySocket.new(host, port)
    @server_replies = @two_way_socket.server_replies
    @two_way_socket.read_write_loop
    @connected = wait_for_connection
  end

  def wait_for_connection
    lines = ""
    lines += @server_replies.pop
    lines += @server_replies.pop
    lines += @server_replies.pop
    lines.include? "NOTICE"
  end

  def register(nickname)
    message = "NICK #{nickname}\nUSER #{nickname} 0 * : #{nickname}"
    @two_way_socket.send(message)
    @registered = wait_for(":End of /MOTD command")
  end

  def wait_for(token)
    while (reply = @server_replies.pop)
      return true if reply.include? token
    end
  end

  def has_channels
    @two_way_socket.send("LIST")
    wait_for ":End of /LIST"
  end

  private

  def server_name_from_pong_message(line)
    line.split(":").last
  end
end
