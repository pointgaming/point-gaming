module Betable
  extend ActiveSupport::Concern

  included do
    has_many :bets, as: :betable
  end
end
