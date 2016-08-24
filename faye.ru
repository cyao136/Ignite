require 'faye'
require File.expand_path('../config/initializers/faye_tokens.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != NOTIFICATION_TOKEN
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    if message['ext'] && message['ext']['auth_token']
      message['ext'] = {} 
    end
    callback.call(message)
  end
end

Faye::WebSocket.load_adapter('thin')
faye_app = Faye::RackAdapter.new(:mount => '/notification', :timeout => 25)
faye_app.add_extension(ServerAuth.new)
run faye_app