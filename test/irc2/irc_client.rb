require "socket"

class IrcClientAsync
  attr_reader :connected, :registered

  def initialize(host, port)
    @two_way_socket = TwoWaySocket.new(host, port)
    @server_replies = @two_way_socket.server_replies
    @client_messages = @two_way_socket.client_messages
    @socket = @two_way_socket.socket
    read_write_loop
    @connected = wait_for_connection
  end

  def read_write_loop
    Thread.new do
      loop do
        if @socket.wait_readable(0.2)
          response = @socket.gets
          if is_pong(response)
            server = server_name_from_pong_message(response)
            @socket.puts "PONG :#{server}"
          else
            @server_replies.push(response)
          end

        else
          begin
            message = @client_messages.pop(true)
            @socket.puts message
          rescue ThreadError
          end
        end
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

  def register(nickname)
    message = "NICK #{nickname}\nUSER #{nickname} 0 * : #{nickname}"
    @client_messages.push(message)
    @registered = wait_for(":End of /MOTD command")
  end

  def wait_for(token)
    while (reply = @server_replies.pop)
      return true if reply.include? token
    end
  end

  def has_channels
    @client_messages.push("LIST")
    wait_for ":End of /LIST"
  end

  private

  def server_name_from_pong_message(line)
    line.split(":").last
  end

  def is_pong(response)
    !response.nil? && response.start_with?("PING")
  end
end

class TwoWaySocket
  attr_reader :server_replies, :client_messages, :socket

  def initialize(host, port)
    @server_replies = Queue.new
    @client_messages = Queue.new
    @socket = TCPSocket.new(host, port)
  end
end
