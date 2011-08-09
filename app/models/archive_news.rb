# The connection between a news items and an archive.
# Each news item must be mapped to one or more archives.

class ArchiveNews < ActiveRecord::Base
  include Inkling::Util::Slugs, ContentPathIncludesArchive

  acts_as_inkling 'ArchiveNews'

  belongs_to :news
  belongs_to :archive

  validates_presence_of :archive
  validates_presence_of :news

  scope :recent, proc { { :limit => 10, :order => "created_at DESC" } }

  def title
    news.title
  end

  # This method creates the slug to store on the Inkling::Path (see Inkling::Path) 
  def generate_path_slug
    slug = "/#{archive.slug}/news/#{ymd}/#{sluggerize(news.title)}"
  end
  
  def ymd
    news.updated_at.strftime("%Y/%m/%d")
  end
  
  def to_feedable
    {:title => news.title, :url => "#{BASE_URL}#{urn}", :updated_at => created_at, :text => news.body}
  end
end
