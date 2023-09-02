# frozen_string_literal: true
require "socket"

class TwoWaySocket
  attr_reader :server_replies, :client_messages, :socket

  def initialize(host, port, client)
    @server_replies = Queue.new
    @client_messages = Queue.new
    @socket = TCPSocket.new(host, port)
    @client = client
    read_write_loop
  end

  def read_write_loop
    Thread.new do
      loop do
        readable ? read : write
      end
    end
  end

  def listen_for(token)
    while (reply = @server_replies.pop)
      return true if reply.include? token
    end
  end

  def send(message)
    @client_messages.push(message)
  end


  private

  def readable
    @socket.wait_readable(0.2)
  end

  def write
    begin
      message = @client_messages.pop(true)
      @socket.puts message
    rescue ThreadError
    end
  end

  def read
    response = @socket.gets
    if @client.approve_immediate response
      @client.respond_to response
    else
      @server_replies.push(response)
    end
  end
end
