class HomeController < ApplicationController
  def index
    @repos = Repo.asc(:name)
  end
end
