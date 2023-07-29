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
    @socket.puts "NICK #{nickname}"
    @socket.puts "USER #{nickname} 0 * : #{nickname}"
    until @socket.eof?
      line = @socket.gets
      puts line
      if line.include? ":End of /MOTD command"
        @registered = true
        break
      end
    end
  end

  attr_reader :connected, :registered

  def connect(host, port)
    @socket = Timeout::timeout(10) do
      TCPSocket.new(host, port)
    end
    @connected = read_until("NOTICE")
  end

  def has_channels
    @socket.puts("LIST")
    string_frozen_ = ":End of /LIST"
    @lines = read_lines_until(string_frozen_)
    puts @lines
    @lines.length.positive?
  end

  def read_until(string_frozen_)
    until no_more_messages
      line = @socket.gets
      puts line
      return true if line.include?(string_frozen_)
    end
    false
  end

  def no_more_messages
    @socket.eof?
  end

  private

  def read_lines_until(string_frozen_)
    lines = []
    until @socket.eof?
      line = @socket.gets
      lines.append(line)
      break if line.include?(string_frozen_)
    end
    lines
  end
end
