class Stream
  include Mongoid::Document
  include Mongoid::Paperclip
  include Sluggable
  include Avatarable

  slug_field :name

  belongs_to :user

  field :name,            type: String
  field :description,     type: String
  field :channel_source,  type: String, default: "twitch"
  field :channel_name,    type: String

  validates :name,            presence: true, uniqueness: true
  validates :channel_source,  presence: true, format: /\A(twitch|youtube)\z/
  validates :channel_name,    presence: true
end
