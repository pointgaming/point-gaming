class CollaboratorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_stream

  def index
    render partial: "index", layout: false
  end

  def create
    @stream.collaborators << BSON::ObjectId.from_string(params[:user_id])
    @stream.collaborators.uniq!
    @stream.save

    head :ok
  end

  def destroy
    id = User.find(params[:id]).id.to_s
    @stream.collaborators.delete_if { |c| c.to_s == id }
    @stream.save

    head :ok
  end

  private
  def get_stream
    @stream = Stream.find(params[:stream_id])

    unless @stream.collaborator?(current_user)
      redirect_to root_path, alert: "Access denied."
    end
  end
end
