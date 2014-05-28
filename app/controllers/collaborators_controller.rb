class CollaboratorsController < ApplicationController
  include Streamable

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
end
