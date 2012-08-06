class ReposController < ApplicationController

  def index
    if params[:lang]
      @lang = params[:lang]
      @repos = Repo.where(language: @lang).asc(:name)
    else
      @repos = Repo.asc(:name)
    end
  end

  def show
    full_name = params[:id]
    @repo = Repo.where(full_name: full_name).first
  end

  def create
    full_name = Repo.parse_input(params[:repo][:full_name])
    if Repo.where(full_name: full_name).exists?
      redirect_to root_url, alert: "'#{full_name}' has already been added."
    else
      begin
        Repo.create_from_github_api(full_name, current_user.login)
        redirect_to root_url, notice: "Thanks for adding '#{full_name}'!"
      rescue
        redirect_to root_url, alert: "'#{full_name}' is not a valid repository."
      end
    end
  end

  def destroy
    full_name = params[:id]
    @repo = Repo.where(full_name: full_name).first
    @repo.destroy
    redirect_to root_url, notice: "Repository deleted."
  end

  def vote
    full_name = params[:id]
    repo = Repo.where(full_name: full_name).first
    current_user.vote_on(repo)
    redirect_to :back, notice: "You voted!"
  end

  def unvote
    full_name = params[:id]
    repo = Repo.where(full_name: full_name).first
    current_user.unvote_on(repo)
    redirect_to :back, notice: "You unvoted!"
  end

  def comment
    comment = Comment.new(username: current_user.login, body: params[:comment][:body])
    if comment.valid?
      full_name = params[:id]
      repo = Repo.where(full_name: full_name).first
      repo.comments << comment
      redirect_to :back, notice: "Comment posted."
    else
      redirect_to :back, alert: "You forgot to type your comment before submitting it."
    end
  end

  def delete_comment
    full_name = params[:repo_id]
    repo = Repo.where(full_name: full_name).first
    repo.comments.find(params[:id]).destroy
    redirect_to :back, notice: "Comment deleted."
  end

end
