class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # for all Users (those who log in + owners of submitted repos)
  field :_id,        type: String,  default: ->{ login }
  field :login,      type: String
  field :name,       type: String
  field :avatar_url, type: String

  # for Users who log in
  field :last_login, type: DateTime
  field :voted_on,   type: Array,   default: []

  field :admin,      type: Boolean, default: false

  def self.create_from_github_api(login)
    json = Octokit.user(login)
    create_from_github_api_json(json)
  end

  def self.create_from_github_api_json(json)
    create! do |user|
      user.login      = json['login']
      user.name       = json['name']
      user.avatar_url = json['avatar_url']
    end
  end

  def github_url
    "http://github.com/" + login
  end

  def repos
    Repo.where(username: login)
  end

  def repos?
    Repo.where(username: login).exists?
  end

  def vote_on(repo)
    unless voted_on? repo
      repo.inc(:votes, 1)
      push(:voted_on, repo.full_name)
    end
  end

  def unvote_on(repo)
    if voted_on? repo
      repo.inc(:votes, -1)
      pull(:voted_on, repo.full_name)
    end
  end

  def voted_on?(repo)
    voted_on.include? repo.full_name
  end
end
