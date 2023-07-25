# frozen_string_literal: true

require "timeout"
require "socket"

class IrcClient
  def initialize(host, port, timeout)
    @host = host
    @port = port
    @timeout = timeout
    @lines = ""
    @socket = make_socket
  end

  def connect
    while (line = @socket.gets) # Read lines from the @socket
      @lines += line.chop
      if line.include? "Couldn't look up your hostname"
        break
      end
    end

  rescue Timeout::Error => e
    @lines = ""
  rescue Errno::ECONNREFUSED => e
    @lines = ""
  end

  def connected
    @lines.include? "NOTICE"
  end

  def register(name, nickname)
    @nickname = nickname
    nick_command(nickname)
    @socket.puts("USER #{nickname} 0 * : #{name}")
    while (line = @socket.gets) # Read lines from the @socket
      @lines += line.chop
      if line.include? ":End of /MOTD command."
        break
      end
    end
  end

  def registered
    @lines.include? "NOTICE * :*** No Ident response" and @lines.include? ":Welcome"
  end

  def make_socket
    Timeout.timeout(@timeout) do
      TCPSocket.open(@host, @port)
    end
  end

  private

  def nick_command(nickname)
    @lines = ""
    @socket.puts("NICK #{nickname}")
    while (line = @socket.gets) # Read lines from the @socket
      @lines += line.chop
      if line.include? "NOTICE * :*** No Ident response"
        break
      end
    end
  end
end
