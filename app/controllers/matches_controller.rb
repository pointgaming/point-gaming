class MatchesController < ApplicationController
  include Streamable

  def index
    render partial: "index", layout: false
  end

  def create
    @match = @stream.matches.create(new_match_params)

    if @match.errors.present?
      render json: @match.errors.first, status: :unprocessable_entity
    else
      render json: @match
    end
  end

  def update
    @match = @stream.matches.where(:workflow_state.ne => "finalized").first

    if @match
      @match.set_winner!(update_match_params) if @match.stopped?
      @match.next_state!
    end

    render json: @match
  rescue
    render json: @match
  end

  def destroy
    @stream.matches.find(params[:id]).deactivate!
    render json: @match
  end

  private
  def new_match_params
    params.require(:match).permit(:player1, :player2, :game, :map)
  end

  def update_match_params
    params.require(:match).permit(:winner)
  end
end
