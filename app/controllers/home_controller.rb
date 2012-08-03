class HomeController < ApplicationController
  def index
    @repos = Repo.desc(:votes)
  end

  def about
  end
end
