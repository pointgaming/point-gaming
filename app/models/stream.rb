class Stream
  include Mongoid::Document
  include Sluggable

  slug_field :name

  belongs_to :user

  field :name, type: String
end
