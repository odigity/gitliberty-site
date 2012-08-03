class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id,        type: String,  default: ->{ login }
  field :login,      type: String
  field :name,       type: String
  field :avatar_url, type: String
  field :voted_on,   type: Array,   default: []
  field :admin,      type: Boolean, default: false

  def self.from_omniauth(auth)
    if Rails.env.production?
      where(login: auth['info']['nickname']).first || create_from_omniauth(auth)
    else
      where(login: auth['uid']).first || create_from_github_api(auth['uid'])
    end
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.login      = auth['info']['nickname']
      user.name       = auth['info']['name']
      user.avatar_url = auth['info']['image']
    end
  end

  def self.create_from_github_api(login)
    json = Octokit.user(login)
    create! do |user|
      user.login      = json['login']
      user.name       = json['name']
      user.avatar_url = json['avatar_url']
    end
  end

  def github_url
    "http://github.com/" + login
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
