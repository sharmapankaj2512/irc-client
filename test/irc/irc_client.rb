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
    until @socket.eof?
      line = @socket.gets
      puts line
      @connected = line.include? "NOTICE"
      break if @connected
    end
  end
end
