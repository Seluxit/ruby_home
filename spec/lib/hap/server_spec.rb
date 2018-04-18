require 'spec_helper'
require 'net/http'

RSpec.describe RubyHome::Server do
  let(:host) { 'localhost' }
  let(:port) { 5678 }

  before(:all) do
    webrick_options = {
      BindAddress: 'localhost',
      Logger: WEBrick::Log.new("/dev/null"),
      Port: 5679
    }

    @proxyable = WEBrick::HTTPServer.new(webrick_options).tap do |server|
      server.mount_proc '/' do |req, res|
        res.body = 'Hello World!'
      end
    end

    Thread.new { @proxyable.start }
  end

  after(:all) do
    @proxyable.shutdown
  end

  around(:each) do |example|
    @server = RubyHome::Server.new(host, port, 'localhost', 5679)
    thread = Thread.new { @server.start }

    example.run

    @server.close
  end

  it 'responds with a body' do
    http_client = Net::HTTP.new(host, port)
    response = http_client.get('/')
    expect(response.body).to eql("Hello World!")
  end

  it 'responds with HTTP/1.1' do
    http_client = Net::HTTP.new(host, port)
    response = http_client.get('/')
    expect(response.http_version).to eql('1.1')
  end

  it 'responds with HTTP keep-alive header' do
    http_client = Net::HTTP.new(host, port)
    response = http_client.get('/')
    expect(response.header['Connection']).to eql('Keep-Alive')
  end

  it 'responds with HTTP Content-Length header' do
    http_client = Net::HTTP.new(host, port)
    response = http_client.get('/')
    expect(response.header['Content-Length']).to eql('12')
  end

  it 'responds with HTTP status code 200' do
    http_client = Net::HTTP.new(host, port)
    response = http_client.get('/')
    expect(response.code).to eql('200')
  end

  it 'adds the socket to socket array' do
    Net::HTTP.start(host, port) do |http_client|
      http_client.get('/')

      client_socket = http_client.instance_variable_get(:@socket).io
      client_socket_port = client_socket.local_address.ip_port

      server_client_ports = RubyHome::Server::SOCKETS
        .flat_map(&:remote_address)
        .flat_map(&:ip_port)

      expect(server_client_ports).to include(client_socket_port)
    end
  end

  it 'rescues from a broken pipe' do
    expect {
      Net::HTTP.start(host, port).finish
    }.not_to raise_error
  end
end
