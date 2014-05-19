class Bet
  include Mongoid::Document

  belongs_to :challenger, user_class: "User"
  belongs_to :taker,      user_class: "User"
  belongs_to :betable,    polymorphic: true

  field :points, type: Integer
  field :odds,   type: Float
end
