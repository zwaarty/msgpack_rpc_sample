require 'msgpack/rpc'

# Delayed return

class Service
  def initialize
    @gen = Random.new
    @size = 1_000
    @inputs = Array.new(@size) { @gen.rand(100) }
    @results = []
  end

  def get
    as = MessagePack::RPC::AsyncResult.new
    Thread.new do
      sleep 0.1
      input = @inputs.shift
      if input
        # puts "send input:#{input}"
        as.result input
      else
        as.result nil
      end
    end
    as
  end

  def post result
    @results << result
    puts "receive result:#{result}"
    result
  end
end

if $0 == __FILE__
  loop = MessagePack::RPC::Loop.new

  inp1 = MessagePack::RPC::Server.new(loop)
  inp2 = MessagePack::RPC::Server.new(loop)
  res1 = MessagePack::RPC::Server.new(loop)
  inp1.listen("localhost", 5000, Service.new)
  inp2.listen("localhost", 5001, Service.new)
  res1.listen("localhost", 5002, Service.new)

  Signal.trap(:TERM) { svr.stop }
  Signal.trap(:INT)  { svr.stop }

  inp1.run
  inp2.run
  res1.run
end
