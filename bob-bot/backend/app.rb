require 'em-websocket'
require_relative 'lib/responser'

EM.run do
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onmessage { |msg|
      responser ||= Responser.new
      ws.send responser.get_answer(msg).dup
    }
  end
end
