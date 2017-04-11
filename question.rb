class Question
  attr_accessor :title, :body, :user_id
  attr_reader :id

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL
    return nil if results.empty?

    self.new(results.first)
  end

  def initialize(options)
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
    @id = options['id']
  end

  def self.find_by_author_id(author_id)
    user = User.find_by_id(author_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?;
    SQL

    results.map { |result| self.new(result) }
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Follow.followers_for_question_id(@id)
  end
end