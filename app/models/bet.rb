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

  belongs_to  :challenger, class_name: "User"
  belongs_to  :taker,      class_name: "User"
  embedded_in :match

  field :player,  type: Integer
  field :points,  type: Integer,  default: 0
  field :odds,    type: Float,    default: 0.5

  validates :points,  presence: true
  validates :odds,    presence: true
  validates :player,  presence: true,
                      numericality: { greater_than_or_equal_to: 1,
                                      less_than_or_equal_to: 2 }
end
