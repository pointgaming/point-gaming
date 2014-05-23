class ChatController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      redis_thread = nil
      channel = "chat.#{params[:channel_id]}"

      tubesock.onopen do
        redis_thread = Thread.new do
          # Needs its own redis connection to pub
          # and sub at the same time
          Redis.new.subscribe channel do |on|
            on.message do |chan, message|
              tubesock.send_data message
            end
          end
        end
      end

      tubesock.onmessage do |data|
        data = JSON.parse(data) rescue nil

        if data && data.is_a?(Hash)
          data[:username] = current_user.username
          data[:slug]     = current_user.slug
          data[:avatar]   = current_user.avatar

          Redis.new.publish channel, JSON(data)
        end
      end

      tubesock.onclose do
        redis_thread.kill
      end
    end
  end
end
