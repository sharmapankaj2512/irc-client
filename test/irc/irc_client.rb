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
    return if @socket.nil?

    while (line = @socket.gets) # Read lines from the @socket
      @lines += line.chop
      if line.include? "Couldn't look up your hostname"
        break
      end
    end
  end

  def connected
    @lines.include? "NOTICE"
  end

  def register(name, nickname)
    @nickname = nickname
    nick_command(nickname)
    user_command(name, nickname)
  end

  def registered
    @lines.include? "NOTICE * :*** No Ident response" and @lines.include? ":Welcome"
  end

  def make_socket
    begin
      Timeout.timeout(@timeout) do
        TCPSocket.open(@host, @port)
      end
    rescue Timeout::Error
      @lines = ""
      nil
    rescue Errno::ECONNREFUSED
      @lines = ""
      nil
    end
  end

  private

  def user_command(name, nickname)
    @socket.puts("USER #{nickname} 0 * : #{name}")
    while (line = @socket.gets) # Read lines from the @socket
      @lines += line.chop
      if line.include? ":End of /MOTD command."
        break
      end
    end
  end

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
