class SessionsController < ApplicationController

  def forward
    redirect_to GithubOAuth.authorize_url(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], false)
  end

  def create
    access_token = GithubOAuth.token(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], params[:code])
    response = HTTParty.get("https://api.github.com/user?access_token=#{access_token}")
    json = JSON.parse(response.body)
    login = json['login']

    # create if doesn't exist yet
    User.where(login: login).exists? or User.create_from_github_api_json(json)

    # remember user between requests
    session[:login] = login

    redirect_to root_url, notice: "You have successfully logged in!"
  end

  def destroy
    session[:login] = nil
    redirect_to root_url, notice: 'You have successfully logged out!'
  end

end
