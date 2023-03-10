require "socket"

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  # "GET /?rolls=2&sides=6 HTTP/1.1"

  http_method = request_line.scan(/\A\w+/).first
  path = request_line.scan(/\/[^?]*/).first
  query_string = request_line.scan(/\?\S*/).first
  params_arr = query_string.scan(/[^?=&]+/)
  params = Hash.new(0)
  params_arr.each_slice(2) { |arr| params[arr.first] = arr.last}

  client.puts request_line
  client.puts "path: #{path}"
  client.puts "query string: #{query_string}"
  client.puts "params: #{params}"

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  rolls.times do
    roll = rand(sides) + 1
    client.puts "You rolled: #{roll}"
  end

  client.close
end
