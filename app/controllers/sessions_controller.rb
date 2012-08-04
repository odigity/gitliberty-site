class SessionsController < ApplicationController

  def forward
    redirect_to GithubOAuth.authorize_url(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], false)
  end

  def create
    access_token = GithubOAuth.token(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], params[:code])
    response = HTTParty.get("https://api.github.com/user?access_token=#{access_token}")
    json = JSON.parse(response.body)
    redirect_to root_url, notice: "You have successfully logged in! (login=#{json[:login]})"
#    user = User.from_omniauth(env['omniauth.auth'])
#    session[:user_id] = user.id
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'You have successfully logged out!'
  end

end
