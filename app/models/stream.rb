class Stream
  include Mongoid::Document
  include Mongoid::Paperclip
  include Sluggable
  include Avatarable

  slug_by :name

  belongs_to :user
  embeds_many :matches

  field :name,            type: String
  field :description,     type: String
  field :channel_source,  type: String, default: "twitch"
  field :channel_name,    type: String
  field :collaborators,   type: Array, default: []

  validates :name,            presence: true, uniqueness: true
  validates :channel_source,  presence: true, format: /\A(twitch|youtube)\z/
  validates :channel_name,    presence: true

  def collaborator?(user)
    self.user == user || collaborators.include?(user.id)
  end
end
