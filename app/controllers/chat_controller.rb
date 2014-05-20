class ChatController < WebsocketRails::BaseController
  def connected
  end

  def new
    message[:username] = current_user.username
    WebsocketRails["stream.#{message[:stream_id]}"].trigger("chat.new", message)
  end
end
