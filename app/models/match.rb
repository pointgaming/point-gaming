class Match
  include Mongoid::Document
  include Betable

  belongs_to :stream

  field :player1, type: String
  field :player2, type: String
end
