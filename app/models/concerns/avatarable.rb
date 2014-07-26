module Avatarable
  extend ActiveSupport::Concern

  included do
    has_mongoid_attached_file :avatar, default_url: "/assets/pixel-admin/avatar.png"
    validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  end
end
