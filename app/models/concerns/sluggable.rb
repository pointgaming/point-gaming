module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :set_slug

    field :slug, type: String, default: ""

    validates :slug, presence: true, uniqueness: true

    class << self
      def slug_field(symbol)
        @@slug_field = symbol
      end
    end
  end

  def set_slug
    if new_record? || send("#{@@slug_field}_changed?")
      self.slug = send(@@slug_field).downcase.gsub(/\s+/, "-")
    end
  end

  def to_param
    slug
  end
end
