class SocketController < ApplicationController
  include Tubesock::Hijack

  def index
    hijack do |tubesock|
      redis_threads = {} # channel => thread

      tubesock.onmessage do |data|
        data = JSON.parse(data) rescue nil
        next unless valid_message(data)

        if data["action"] == "subscribe" && redis_threads[@channel].blank?
          redis_threads[@channel] = Thread.new do
            Redis.new.subscribe(@channel) do |on|
              on.message do |chan, message|
                tubesock.send_data(message)
              end
            end
          end
        elsif data["action"] == "unsubscribe"
          redis_threads[@channel].try(:kill)
        else
          unless data["action"] == "refresh"
            data[:username] = current_user.username
            data[:slug]     = current_user.slug
          end

          Redis.new.publish @channel, JSON(data)
        end
      end

      tubesock.onclose do
        redis_threads.values.each(&:kill)
      end
    end
  end

  private
  def valid_channel(channel)
    channel = channel.to_s.downcase

    if channel =~ /stream\.([\w\-]+)/
      @channel = channel if Stream.where(slug: $1).exists?
    elsif channel =~ /user\.([a-f0-9]+)/
      @channel = channel if User.where(_id: $1).exists?
    end

    @channel ? true : false
  end

  def valid_message(data)
    actions = ["chat","subscribe","unsubscribe","update","refresh"]

    return false unless data && data.is_a?(Hash)
    return false unless actions.include?(data["action"])
    return false unless valid_channel(data["channel"])

    true
  end
end
