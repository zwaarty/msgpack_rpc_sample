require 'msgpack/rpc'

class Client < MessagePack::RPC::Client
  def get
    input = call(:get)
    if input
      puts "get input:#{input}"
      input
    else
      nil
    end
  end

  def post result
    call(:post, result)
    puts "post result:#{result}"
  end
end

if $0 == __FILE__
  cli = Client.new("localhost", 5000)
  cli.timeout = 5

  rgen = Random.new(100)

  100.times do
    sleep rgen.rand(5)
    input = cli.get

    sleep rgen.rand(5)
    result = Math.sin(input)
    cli.post(result)
  end

  cli.close
end
