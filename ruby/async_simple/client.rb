require 'msgpack/rpc'

# Asynchronous call with multiple servers

class Client < MessagePack::RPC::Client
  def input
    future = call_async(:get)
    # puts "get input future"
    future
  end

  def post result
    call_async(:post, result)
    puts "post result"
  end
end

if $0 == __FILE__
  loop = MessagePack::RPC::Loop.new

  inp1 = Client.new("localhost", 5000, loop)
  inp2 = Client.new("localhost", 5001, loop)
  res1 = Client.new("localhost", 5002, loop)
  inp1.timeout = 10
  inp2.timeout = 10
  res1.timeout = 10

  rgen = Random.new(100)

  loop do
    sleep rgen.rand(3)
    future1 = inp1.input
    future2 = inp2.input
    val1 = future1.get
    puts "get input: #{val1}"
    val2 = future2.get
    puts "get input: #{val2}"

    sleep rgen.rand(3)
    result = val1 + val2
    res1.post(result)
  end

  inp1.close
  inp2.close
  res1.close
end
