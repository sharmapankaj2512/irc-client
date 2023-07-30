require "socket"

class IrcClientAsync
  attr_reader :connected, :registered

  def initialize(host, port)
    @server_replies = Queue.new
    @client_messages = Queue.new
    @socket = TCPSocket.new(host, port)
    read_write_loop
    @connected = wait_for_connection
  end

  def read_write_loop
    Thread.new do
      loop do
        if @socket.wait_readable(0.2)
          line = @socket.gets
          @server_replies.push(line)
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
    puts lines
    lines.include? "NOTICE"
  end

  def wait_for_registration
    while (reply = @server_replies.pop)
      puts reply
      return true if reply.include? ":End of /MOTD command"
    end
  end

  def register(nickname)
    message = "NICK #{nickname}\nUSER #{nickname} 0 * : #{nickname}"
    @client_messages.push(message)
    @registered = wait_for_registration
  end

  def wait_for_channels
    while (reply = @server_replies.pop)
      puts reply
      return true if reply.include? ":End of /LIST"
    end
  end

  def has_channels
    @client_messages.push("LIST")
    wait_for_channels
  end
end
