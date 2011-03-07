class News < ActiveRecord::Base
  has_many :news_archives, :dependent => :destroy
  has_many :archives, :through => :news_archives
  SNIPPET_WORDS = 20

  belongs_to :user, :class_name => "Inkling::User", :foreign_key => "user_id"

  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :body
  #validates_at_least_one :news_archives
  validates_inclusion_of :state, :in => %w{draft published deleted}

  named_scope :recent, proc { { :limit => 10, :order => "created_at DESC" } }
  named_scope :published, proc { { :conditions => "state = 'published'" } }

  def snippet
    words = body.gsub(/<\/?[^>]*>/, "").split(/\W/m).reject{|w| w.empty? }
    words = words.size > SNIPPET_WORDS ? words[0...SNIPPET_WORDS]+['...'] : words
    words * ' '
  end
end
