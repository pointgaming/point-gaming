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

  def match_button_class(stream)
    if stream.initialized_match?
      if stream.active_match?
        "btn-danger"
      else
        "btn-success"
      end
    else
      "hidden"
    end
  end
end
