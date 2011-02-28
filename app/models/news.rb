class News < ActiveRecord::Base
  has_many :news_archives
  has_many :archive, :through => :news_archives
  belongs_to :user, :class_name => "Inkling::User", :foreign_key => "user_id"

  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :body
  #validates_presence_of :news_archives
  validates_inclusion_of :state, :in => %w{draft published deleted}
end
