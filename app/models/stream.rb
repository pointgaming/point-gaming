class Stream
  include Mongoid::Document
  include Mongoid::Paperclip
  include Sluggable
  include Avatarable

  slug_field :name

  belongs_to :user

  field :name, type: String

  validates :name, presence: true, uniqueness: true
end
