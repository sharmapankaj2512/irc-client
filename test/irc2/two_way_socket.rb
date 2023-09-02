# frozen_string_literal: true
require "socket"

class TwoWaySocket
  attr_reader :server_replies, :client_messages, :socket

  def initialize(host, port)
    @server_replies = Queue.new
    @client_messages = Queue.new
    @socket = TCPSocket.new(host, port)
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

  def send(message)
    @client_messages.push(message)
  end

  def is_pong(response)
    !response.nil? && response.start_with?("PING")
  end
end
