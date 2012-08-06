class Push
  include Mongoid::Document

  field :_id,            type: String, default: ->{ push_id }
  field :push_id,        type: String
  field :when,           type: DateTime
  field :repo_full_name, type: String
  field :commits,        type: Array

  def commits
    self['commits'].map {|c| Commit.demongoize(c)}
  end

  def commits=(array)
    self['commits'] = array.map {|c| c.mongoize}
  end
end
