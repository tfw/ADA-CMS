class News < ActiveRecord::Base
  include ApplicationHelper

  has_many :news_archives, :dependent => :destroy
  has_many :archives, :through => :news_archives
  SNIPPET_WORDS = 20

  belongs_to :user, :class_name => "Inkling::User", :foreign_key => "user_id"

  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :body
  #validates_at_least_one :news_archives
  validates_inclusion_of :state, :in => %w{draft published deleted}

  scope :recent, proc { { :limit => 10, :order => "created_at DESC" } }
  scope :published, proc { { :conditions => "state = 'published'" } }

  def snippet
    first_n_words(SNIPPET_WORDS, body)
  end
end
