class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  field :body,     type: String

  embedded_in :repo

  validates :body, presence: true

  before_create do |comment|
    comment.repo.inc(:comments_count, 1)
  end

  before_destroy do |comment|
    comment.repo.inc(:comments_count, -1)
  end

  def owner
    @owner ||= User.where(login: username).first
  end
end
