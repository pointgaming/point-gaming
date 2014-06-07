module Publishable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :publish_fn
    after_save :publish
    after_destroy :publish

    def publish
      parent = self.class.publish_fn.call(self)
      param = parent.respond_to?(:slug) ? parent.slug : parent.id

      publish_to = "stream.#{param.to_s}"

      Redis.new.publish(publish_to, {
        action: "update",
        class: self.class.to_s.underscore,
        data: self
      }.to_json)
    end

    class << self
      def publish_channel(fn)
        self.publish_fn = fn
      end
    end
  end
end
