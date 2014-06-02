class BetsController < ApplicationController
  include Tubesock::Hijack

  before_filter :authenticate_user!
  before_filter :get_stream, except: :sock

  def index
    render partial: "index", layout: false
  end

  def create
    @bet = active_match.bets.create(new_bet_params)

    if @bet.errors.present?
      render json: @bet.errors.first, status: :unprocessable_entity
    else
      render json: @bet
    end
  end

  def update
    @bet = active_match.bets.find(params[:id])
    @bet.accept!(current_user)

    render json: @bet
  end

  def destroy
    active_match.bets.find(params[:id]).deactivate!
    render json: @bet
  end

  private
  def new_bet_params
    params.require(:bet).permit(:player, :points, :odds)
  end

  def update_bet_params
    params.require(:bet).permit(:winner)
  end

  def active_match
    @match = @stream.active_match

    render nothing: true unless @match
  end
end
