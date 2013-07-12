#escape html/xss
include ERB::Util

Thread.abort_on_exception = true

Thread.new do
  EventMachine.run do
    @sockets = Array.new
    EventMachine::WebSocket.start($em_config) do |ws|
      ws.onopen do
      end

      ws.onclose do
        index = @sockets.index {|i| i[:socket] == ws}
        client = @sockets.delete_at index
        @sockets.each {|s| s[:socket].send h("#{client[:id]} has disconnected!")}
      end

      ws.onmessage do |msg|
        client = JSON.parse(msg).symbolize_keys
        case client[:action]
        when 'connect'
          @sockets.push({:id => client[:id], :socket => ws})
          @sockets.each {|s| s[:socket].send h("#{client[:id]} has connected!")}
        when 'say'
          @sockets.each {|s| s[:socket].send h("#{client[:id]} says : #{client[:data]}")}
        when 'move'
        end
      end
    end
  end
end

