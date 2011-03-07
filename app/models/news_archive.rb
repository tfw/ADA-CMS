# The connection between a news items and an archive.
# Each news item must be mapped to one or more archives.

class NewsArchive < ActiveRecord::Base
  include Inkling::Util::Slugs, ContentPathIncludesArchive

  acts_as_inkling 'NewsArchive'

  belongs_to :news
  belongs_to :archive

  validates_presence_of :archive
  validates_presence_of :news

  named_scope :recent, proc { { :limit => 10, :order => "created_at DESC" } }

  # This method creates the slug to store on the Inkling::Path (see Inkling::Path) 
  def generate_path_slug
    slug = "/#{archive.slug}/"
    slug += sluggerize(news.title)
  end
end
