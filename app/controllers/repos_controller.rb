class ReposController < ApplicationController

  def create
    full_name = Repo.parse_input(params[:repo][:full_name])
    if Repo.where(full_name: full_name).exists?
      redirect_to root_url, alert: "'#{full_name}' has already been added."
    else
      Repo.create_from_github_api(full_name, current_user.login)
      redirect_to root_url, notice: "Thanks for adding '#{full_name}'!"
    end
  end

  def index
    @repos = Repo.asc(:name)
  end

  def show
  end

end
