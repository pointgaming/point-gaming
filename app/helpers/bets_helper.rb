module BetsHelper
  def player_options(stream)
    match = stream.betable_match

    if match
      [ [match.player1, 1],
        [match.player2, 2] ]
    else
      []
    end
  end
end
