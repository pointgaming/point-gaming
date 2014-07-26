class UsersController < ApplicationController
  def search
    @users = User.where(username: /#{params[:query]}/i).limit(5)

    render json: @users, only: [:_id, :username, :slug]
  end

  def update
    if current_user.update_attributes(update_user_params)
      redirect_to :back, notice: "Updated successfully!"
    else
      redirect_to :back, alert: "There was a problem with your submission."
    end
  end

  private
  def update_user_params
    params.require(:user).permit(:avatar, :password, :password_confirmation)
  end
end
