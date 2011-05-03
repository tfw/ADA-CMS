#this class will be redundant when we finish the openid inkling refactor

class UserReport < User

  has_many :pages, :foreign_key => "author_id"
  has_many :news, :foreign_key => "user_id"
  has_many :archive_study_integrations, :foreign_key => "user_id"

end