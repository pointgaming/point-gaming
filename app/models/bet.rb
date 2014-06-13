class Bet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Workflow
  include WorkflowMongoid
  include Publishable

  publish_channel ->(bet){ bet.match.stream }

  workflow do
    state :initialized do
      event :accept, transitions_to: :accepted
    end

    state :accepted do
      event :finalize, transitions_to: :finalized
    end

    state :finalized
  end

  before_create :deduct_points_from_challenger

  belongs_to  :challenger, class_name: "User"
  belongs_to  :taker,      class_name: "User"
  embedded_in :match

  field :player,  type: Integer
  field :points,  type: Integer,  default: 0
  field :odds,    type: Integer,  default: 0

  validates :player,  presence: true, numericality: { greater_than: 0, less_than: 3 }
  validates :points,  presence: true, numericality: { greater_than: 0 }
  validates :odds,    presence: true

  validate do |bet|
    bet.errors.add :base, "Cannot take your own challenges." if bet.challenger == bet.taker
  end

  validate do |bet|
    if bet.stream.collaborator?(bet.challenger) || bet.stream.collaborator?(bet.taker)
      bet.errors.add :base, "Cannot bet on your own stream."
    end
  end

  def can_be_accepted_by?(user)
    initialized? && user.points >= points_required_to_accept && challenger != user && !stream.collaborator?(user)
  end

  def accept(user)
    self.taker = user

    taker.inc({ points: -points_required_to_accept })

    publish_points
  end

  def finalize
    winner = match.winner
    total_points = points + points_required_to_accept

    if winner
      bet_winner = (winner == player ? challenger : taker)
      bet_winner.inc({ points: total_points })
    end

    publish_points
  end

  def publish_points
    [taker, challenger].compact.each do |better|
      Redis.new.publish("user.#{better.id}", JSON({ action: "points", points: better.points }))
    end
  end

  def points_required_to_accept
    if odds == -3
      points + (points * 0.5)
    elsif odds == -2
      points + (points * 0.25)
    elsif odds == -1
      points + (points * 0.1)
    elsif odds == 0
      points
    elsif odds == 1
      points * 0.5
    elsif odds == 2
      points * 0.25
    elsif odds == 3
      points * 0.1
    end.round
  end

  def stream
    match.stream
  end

  private
  def deduct_points_from_challenger
    challenger.inc({ points: -points })
    publish_points
  end
end
