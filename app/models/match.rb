class Match
  include Mongoid::Document
  include Mongoid::Timestamps
  include Workflow
  include WorkflowMongoid
  include Betable

  workflow do
    state :initialized do
      event :start, transitions_to: :started
    end

    state :started do
      event :stop, transitions_to: :stopped
    end

    state :stopped do
      event :finalize, transitions_to: :finalized
    end

    state :finalized
  end

  embedded_in :stream

  field :player1, type: String
  field :player2, type: String
  field :game,    type: String
  field :winner,  type: Integer
  field :map,     type: String

  validates :game, presence: true
  validates :winner, numericality: { integer: true, greater_than: 0, less_than: 3, allow_blank: true }

  validate do |match|
    if stream.matches.where(:_id.not => match.id).
        where(:workflow_state.ne => "finalized").exists?
      match.errors.add :base, "Finalize all previous matches first."
    end
  end

  def deactivate!
    set(active: false)
  end

  def set_winner!(params)
    winner = params[:winner]

    if player1 == winner
      set(winner: 1)
    elsif player2 == winner
      set(winner: 2)
    end
  end
end
