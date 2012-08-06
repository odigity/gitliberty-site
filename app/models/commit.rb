class Commit

  attr_accessor :sha, :message, :github_url

  ## Class Methods

  def self.demongoize(obj)
    new(sha: obj[0], message: obj[1], github_url: obj[2])
  end

  def self.mongoize(obj)
    obj.mongoize
  end

  def self.evolve(obj)
    obj.mongoize
  end

  ## Instance Methods

  def initialize(args)
    @sha        = args[:sha]
    @message    = args[:message]
    @github_url = args[:github_url]
  end

  def mongoize
    [ @sha, @message, @github_url ]
  end

end
