class Match
  include Mongoid::Document
  include Mongoid::Timestamps
  include Betable

  embedded_in :stream

  field :player1, type: String
  field :player2, type: String
  field :game,    type: String
  field :active,  type: Boolean, default: false
  field :winner,  type: Integer, default: 0

  validates :game, presence: true
  validates :winner, numericality: { integer: true, greater_than_or_equal_to: 0, less_than: 3, allow_blank: true }

  validate do |match|
    if stream.matches.any_of({ active: true }, { active: false, winner: 0 }).where(:_id.not => match.id).exists?
      match.errors.add :base, "Finalize all previous matches first."
    end
  end

  def deactivate!
    set(active: false)
  end
end
