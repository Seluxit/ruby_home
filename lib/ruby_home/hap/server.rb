require 'socket'
require 'byebug'

module RubyHome
  class Server < TCPServer
    def initialize(host_name, host_port, remote_name, remote_port)
      @remote_name = remote_name
      @remote_port = remote_port

      super(host_name, host_port)
    end

    SOCKETS = []

    def accept
      super.tap do |socket, _|
        SOCKETS << socket
      end
    end

    def start
      begin
        loop do
          Thread.new accept, &method(:handle_request)
        end
      rescue Errno::EBADF, IOError
      ensure
        close
      end
    end

    def close
      SOCKETS.clear
      super
    end

    private

    attr_reader :remote_name, :remote_port

    def handle_request(client_socket)
      begin
        if request_line = client_socket.gets
          server_socket = TCPSocket.new(remote_name, remote_port)
          server_socket.write(request_line)
          server_socket.write("Host: #{remote_name}:#{remote_port}\r\n")
          server_socket.write("Connection: close\r\n")
          server_socket.write("\r\n")

          while line = server_socket.gets
            if line =~ /^connection/i
              client_socket.write("Connection: Keep-Alive\r\n")
            else
              client_socket.write(line)
            end
          end

          server_socket.close
        end
      rescue Errno::EPIPE, Errno::ECONNRESET, Errno::ENOTCONN
        client_socket.close
      end
    end
  end
end
