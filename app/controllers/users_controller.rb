class UsersController < ApplicationController

  def index
    @users = User.asc(:login)
  end

  def show
    @user = User.where(login: params[:id]).first
  end

end
