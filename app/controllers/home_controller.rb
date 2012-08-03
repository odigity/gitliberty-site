class HomeController < ApplicationController
  def index
    @repos = Repo.asc(:name)
  end

  def about
  end
end
