# frozen_string_literal: true
require 'socket'
require 'timeout'

class IrcClient
  def initialize(host, port)
    begin
      connect(host, port)
    rescue SocketError
      @connected = false
    rescue Timeout::Error
      @connected = false
    end
  end

  def register(nickname)
    send_command "NICK #{nickname}"
    send_command "USER #{nickname} 0 * : #{nickname}"
    notice_commands = read_lines_until ":End of /MOTD command"
    @registered = notice_commands.length.positive?
  end

  attr_reader :connected, :registered

  def connect(host, port)
    @socket = Timeout.timeout(10) do
      TCPSocket.new(host, port)
    end
    @connected = replied_with_notice
  end

  def has_channels
    @socket.puts("LIST")
    channels = read_lines_until(":End of /LIST")
    channels.length.positive?
  end

  def no_more_messages
    @socket.eof?
  end

  private

  def send_command(string_frozen_)
    @socket.puts string_frozen_
  end

  def replied_with_notice
    read_lines_until("NOTICE").length.positive?
  end

  def read_lines_until(string_frozen_)
    lines = []
    until @socket.eof?
      line = @socket.gets
      lines.append(line)
      break if line.include?(string_frozen_)
    end
    puts lines
    lines
  end
end
