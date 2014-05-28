class Bet
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :challenger, class_name: "User"
  belongs_to :taker,      class_name: "User"
  belongs_to :betable,    polymorphic: true

  field :points, type: Integer
  field :odds,   type: Float
end
