class News < ActiveRecord::Base
  include ApplicationHelper, Workflowable

  attr_protected :state #nice and simple protection until we get to Rails 3.1

  versioned

  has_many :archive_news, :dependent => :destroy
  has_many :archives, :through => :archive_news
  SNIPPET_WORDS = 20

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :body

  scope :recent, proc { { :limit => 10, :order => "created_at DESC" } }
  scope :published, proc { { :conditions => "state = 'published'" } }
end
