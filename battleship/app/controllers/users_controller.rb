class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      render 'new'
    end
  end

  def destroy
    redirect_to '/'
  end

private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
