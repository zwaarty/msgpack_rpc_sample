require 'msgpack/rpc'

class Service
  def initialize
    @gen = Random.new(100)
    @size = 1_000
    @inputs = Array.new(@size) { @gen.rand(100) }
    @results = []
  end

  def get
    input = @inputs.shift
    if input
      puts "send input:#{input}"
      input
    else
      nil
    end
  end

  def post result
    @results << result
    puts "receive result:#{result}"
    result
  end
end

if $0 == __FILE__
  svr = MessagePack::RPC::Server.new
  svr.listen("localhost", 5000, Service.new)

  Signal.trap(:TERM) { svr.stop }
  Signal.trap(:INT)  { svr.stop }

  svr.run
end
