require 'faye'
Faye::WebSocket.load_adapter('thin')
faye_app = Faye::RackAdapter.new(:mount => '/notification', :timeout => 25)
run faye_app