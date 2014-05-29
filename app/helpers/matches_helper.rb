module MatchesHelper
  def strong_winner(match, player)
    safe = sanitize(match.send(:"player#{player}"))

    if match.winner == player
      "<strong>#{safe}</strong>"
    else
      safe
    end.html_safe
  end

  def match_class(match)
    if !match.finalized?
      "success"
    elsif match.finalized? && match.winner.nil?
      "danger"
    else
      ""
    end
  end

  def match_button_class(stream)
    if stream.initialized_match? || stream.active_match?
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
