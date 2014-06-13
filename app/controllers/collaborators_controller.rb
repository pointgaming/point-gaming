class CollaboratorsController < ApplicationController
  include Streamable

  def index
    render partial: "index", layout: false
  end

  def create
    user = User.find(params[:user_id])

    if @stream.has_active_bets?(user)
      render json: { error: "Collaborator cannot have any active bets." }, status: :unprocessable_entity
    else
      @stream.collaborators << user.id
      @stream.collaborators.uniq!
      @stream.save

      head :ok
    end
  end

  def destroy
    id = User.find(params[:id]).id.to_s
    @stream.collaborators.delete_if { |c| c.to_s == id }
    @stream.save

    head :ok
  end
end
