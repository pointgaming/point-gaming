module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :set_slug

    field :slug, type: String, default: ""

    validates :slug, presence: true, uniqueness: true

    validate do |sluggable|
      # If the slug is already taken, present it as though the name is already taken.
      if sluggable.class.where(slug: sluggable.slug).exists?
        sluggable.errors.add @@slug_field.to_sym, "is already taken"
      end
    end

    class << self
      def slug_field(symbol)
        @@slug_field = symbol
      end
    end
  end

  def set_slug
    if new_record? || send("#{@@slug_field}_changed?") || slug.blank?
      self.slug = send(@@slug_field).downcase.gsub(/[^\w\s]+/, "").gsub(/\s+/, "-")
    end
  end

  def to_param
    slug
  end
end
