module Sluggable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :slug_field

    before_validation :set_slug

    field :slug, type: String, default: ""

    validates :slug, presence: true, uniqueness: true

    validate do |sluggable|
      # If the slug is already taken, present it as though the name is already taken.
      if sluggable.class.where(slug: sluggable.slug, :_id.ne => sluggable._id).exists?
        sluggable.errors.add sluggable.class.slug_field.to_sym, "is already taken"
      end
    end

    class << self
      def slug_by(symbol)
        self.slug_field = symbol
      end
    end
  end

  def set_slug
    slug_field = self.class.slug_field
    if new_record? || send("#{slug_field}_changed?") || slug.blank?
      self.slug = send(slug_field).parameterize
    end
  end

  def to_param
    slug
  end

  module ClassMethods
    def find(param)
      if BSON::ObjectId.legal?(param)
        super
      else
        find_by(slug: param)
      end
    end
  end
end
