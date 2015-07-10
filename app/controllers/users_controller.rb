class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if user_params.present?
      @user.update_attributes(user_params)
    end
    redirect_to events_path
  end

  def user_params
    params.require(:user).permit(:name, :avatar)
  end

end