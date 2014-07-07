class Stream
  include Mongoid::Document
  include Mongoid::Paperclip
  include Sluggable
  include Avatarable

  slug_by :name

  belongs_to :user
  embeds_many :matches
  after_destroy :send_refresh

  field :name,            type: String
  field :description,     type: String
  field :channel_source,  type: String, default: "twitch"
  field :channel_name,    type: String
  field :collaborators,   type: Array, default: []

  validates :name,            presence: true, uniqueness: true
  validates :channel_source,  presence: true, format: /\A(twitch|youtube)\z/
  validates :channel_name,    presence: true

  def collaborator?(user)
    return false unless user
    self.user == user || collaborators.include?(user.id)
  end

  def has_active_bets?(user)
    return false unless user
    match = betable_match()

    if match.present? && match.bets.any_of({ challenger: user }, { taker: user }).present?
      true
    else
      false
    end
  end

  [:initialized, :active, :betable].each do |t|
    define_method "#{t}_match?" do
      send("#{t}_match_query").exists?
    end
    define_method "#{t}_match" do
      send("#{t}_match_query").first
    end
  end

  [:twitch, :youtube].each do |s|
    define_method "#{s}?" do
      channel_source == "#{s}"
    end
  end

  private
  def initialized_match_query
    matches.where(:workflow_state.in => ["initialized"])
  end

  def active_match_query
    matches.where(:workflow_state.in => ["started","stopped"])
  end

  def betable_match_query
    matches.where(:workflow_state.in => ["initialized","started","stopped"])
  end

  def send_refresh
    Redis.new.publish("stream.#{slug}", JSON({ action: "refresh" }))
  end
end
