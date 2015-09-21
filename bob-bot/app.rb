require 'em-websocket'

def question?(msg)
  !!(msg =~ /\?$/)
end

def capitals?(msg)
  !!(msg =~ /^[A-Z]+$/)
end

def get_answer(msg)
  h = {
    'Sure' => question?(msg),
    'Woah, chill out!' => capitals?(msg),
    'Fine. Be that way!' => msg.empty?,
    'Whatever' => !question?(msg) && !capitals?(msg) && !msg.empty?
  }
  h.key(true)
end

EM.run do
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onmessage { |msg|
      ws.send get_answer(msg).dup
    }
  end
end
