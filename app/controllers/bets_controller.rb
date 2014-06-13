class BetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_stream

  def index
    render partial: "index", layout: false
  end

  def create
    bet = initialized_match.bets.create(new_bet_params.merge(challenger: current_user))

    if bet.errors.present?
      render json: bet.errors.first, status: :unprocessable_entity
    else
      render json: bet
    end
  end

  def update
    bet = initialized_match.bets.find(params[:id])
    bet.accept!(current_user) if bet.can_be_accepted_by?(current_user)

    render json: bet
  end

  private
  def new_bet_params
    params.require(:bet).permit(:player, :points, :odds)
  end

  def initialized_match
    match = @stream.initialized_match
    render nothing: true unless match
    match
  end

  def get_stream
    @stream = Stream.find(params[:stream_id])
  end
end
