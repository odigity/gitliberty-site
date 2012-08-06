class Repo
  include Mongoid::Document
  include Mongoid::Timestamps

  # from GitHub API
  field :full_name,      type: String
  field :description,    type: String
  field :language,       type: String
  field :watchers_count, type: Integer

  # derived
  field :_id,            type: String
  field :username,       type: String
  field :name,           type: String

  field :submitted_by,   type: String
  field :votes,          type: Integer, default: 0

  embeds_many :comments
  field :comments_count, type: Integer, default: 0

  def self.parse_input(val)
    path = URI(val).path
    if path =~ /github.com/i
      path = path.sub(/.*github.com\//i, '')
    end
    /^\/*([\w-]+\/[\w-]+).*/.match(path)[1]
  end

  def self.create_from_github_api(full_name, submitted_by)
    json = Octokit.repo(full_name)
    create!(json.slice(:full_name, :description, :language, :watchers_count).merge(submitted_by: submitted_by))
  end

  def self.languages
    all.distinct(:language).to_a.sort
  end

  before_create do |repo|
    parts = full_name.split('/')
    repo._id      = full_name
    repo.username = parts[0]
    repo.name     = parts[1]
  end

  after_create do |repo|
    User.where(login: repo.username).exists? || User.create_from_github_api(repo.username)
  end

  def github_url
    "http://github.com/" + full_name
  end

  def owner
    @owner ||= User.where(login: username).first
  end
end
