module MatchesHelper
  def strong_winner(match, player)
    safe = sanitize(match.send(:"player#{1}"))

    if match.winner == player
      "<strong>#{safe}</strong>"
    else
      safe
    end.html_safe
  end

  def match_class(match)
    if match.active?
      "success"
    elsif !match.active? && match.winner == nil
      "danger"
    else
      ""
    end
  end
end
