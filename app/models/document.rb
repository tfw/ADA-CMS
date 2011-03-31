class Document < ActiveRecord::Base
  # Inkling:
  include Inkling::Util::Slugs
  acts_as_inkling 'Document'

  # Paperclip:
  has_attached_file :resource,
    :styles => {},
    :path => ':rails_root/public/resources/documents/:attachment/:id/:style/:filename',
    :url => '/resources/documents/:attachment/:id/:style/:filename'

  # Pagination:
  cattr_reader :per_page
  @@per_page = 10

  belongs_to :user, :class_name => "Inkling::User", :foreign_key => "user_id"
  belongs_to :archive

  validates_presence_of :user
  validates_presence_of :title
  def generate_path_slug
    "/documents/#{sluggerize(self.title)}"
  end

  # accessor methods expected by the ckeditor browse views (can refactor, we have our own copies)
  def url_thumb
    "/images/mime_types/#{resource.content_type}.png"
  end

  def url_content
    self.path.slug
  end

  def filename
    self.resource_file_name
  end

  def format_created_at
    self.created_at
  end

  def size
    self.resource_file_size
  end
end
