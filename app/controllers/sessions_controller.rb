class SessionsController < ApplicationController

  def forward
    if Rails.env.development?
      session[:login] = 'odigity'
      @current_user = User.where(login: 'odigity').first
      @current_user.last_login = Time.now
      @current_user.save
      redirect_to root_url, notice: "You have successfully logged in!"
    else
      redirect_to GithubOAuth.authorize_url(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], false)
    end
  end

  def create
    access_token = GithubOAuth.token(ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], params[:code])
    response = HTTParty.get("https://api.github.com/user?access_token=#{access_token}")
    json = JSON.parse(response.body)
    login = json['login']

    # create if doesn't exist yet
    @current_user = User.where(login: login).exists? || User.create_from_github_api_json(json)

    # remember user between requests
    session[:login] = login

    # update last_login timestamp
    @current_user.last_login = Time.now
    @current_user.save

    redirect_to root_url, notice: "You have successfully logged in!"
  end

  def destroy
    session[:login] = nil
    redirect_to root_url, notice: 'You have successfully logged out!'
  end

end
