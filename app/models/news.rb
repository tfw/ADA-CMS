class News < ActiveRecord::Base
  include ApplicationHelper

  has_many :archive_news, :dependent => :destroy
  has_many :archives, :through => :archive_news, :class_name => 'Archive', :foreign_key => "archive_id"
  SNIPPET_WORDS = 20

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :body
  validates_inclusion_of :state, :in => %w{draft published deleted}

  scope :recent, proc { { :limit => 10, :order => "created_at DESC" } }
  scope :published, proc { { :conditions => "state = 'published'" } }
end
