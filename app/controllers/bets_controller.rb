class BetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_stream

  def index
    @match = @stream.betable_match

    render partial: "index", layout: false
  end

  def create
    @bet = initialized_match.bets.create(new_bet_params)

    if @bet.errors.present?
      render json: @bet.errors.first, status: :unprocessable_entity
    else
      render json: @bet
    end
  end

  def update
    @bet = initialized_match.bets.find(params[:id])
    @bet.accept!(current_user)

    render json: @bet
  end

  def destroy
    initialized_match.bets.find(params[:id]).destroy
    render json: @bet
  end

  private
  def new_bet_params
    params.require(:bet).permit(:player, :points, :odds)
  end

  def initialized_match
    @match = @stream.initialized_match

    render nothing: true unless @match
  end
end
