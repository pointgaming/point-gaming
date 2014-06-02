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

  def initialized_match?
    matches.where(workflow_state: "initialized").exists?
  end

  def active_match?
    active_match_query.exists?
  end

  def active_match
    active_match_query.first
  end

  def twitch?
    channel_source == "twitch"
  end

  def youtube?
    channel_source == "youtube"
  end

  private
  def active_match_query
    matches.where(:workflow_state.in => ["started","stopped"])
  end
end
