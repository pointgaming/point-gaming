module Avatarable
  extend ActiveSupport::Concern

  included do
    has_mongoid_attached_file :avatar, default_url: "/assets/pixel-admin/avatar.png"
  end
end
