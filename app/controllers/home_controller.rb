class HomeController < ApplicationController
  def index
    @repos  = Repo.desc(:votes).limit(10)
    @pushes = Push.desc(:when).limit(10)
  end

  def about
  end
end
