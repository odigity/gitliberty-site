class SessionsController < ApplicationController

  def forward
    redirect_to GithubOAuth.authorize_url(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], false)
  end

  def create
    puts "***** SessionsController.create"
    session[:access_token] = GithubOAuth.token(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], params[:code])
    redirect_to root_url, notice: "You have successfully logged in! (ACCESS_TOKEN=#{session[:access_token]})"
#    user = User.from_omniauth(env['omniauth.auth'])
#    session[:user_id] = user.id
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'You have successfully logged out!'
  end

end
