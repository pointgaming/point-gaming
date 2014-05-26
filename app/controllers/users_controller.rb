class UsersController < ApplicationController
  def search
    @users = User.where(username: /#{params[:query]}/i).limit(5)

    render json: @users, only: [:_id, :username, :slug]
  end
end
