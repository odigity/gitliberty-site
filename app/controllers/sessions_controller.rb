class SessionsController < ApplicationController

  def create
    puts "***** SessionsController.create"
    puts "***** auth: #{env['omniauth.auth']}"
    user = User.from_omniauth(env['omniauth.auth'])
    puts "***** user: #{user}"
    session[:user_id] = user.id
    redirect_to root_url, notice: 'You have successfully logged in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'You have successfully logged out!'
  end

  def failure
    puts "***** SessionsController.failure"
    puts "***** auth: #{env['omniauth.auth']}"
  end

end
