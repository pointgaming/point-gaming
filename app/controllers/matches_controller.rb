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

  def destroy
    @stream.matches.find(params[:id]).deactivate!
    render json: @match
  end

  private
  def new_match_params
    params.require(:match).permit(:player1, :player2, :game)
  end
end
