require 'em-websocket'

def question?(msg)
  !!(msg =~ /\?$/)
end

def capitals?(msg)
  !!(msg =~ /^[A-Z]+$/)
end

def not_matched?(msg)
  !question?(msg) && !capitals?(msg) && !msg.empty?
end

def get_answer(msg)
  h = {
    'Sure' => question?(msg),
    'Woah, chill out!' => capitals?(msg),
    'Fine. Be that way!' => msg.empty?,
    'Whatever' => not_matched?(msg)
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
