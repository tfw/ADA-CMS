class Media < ActiveRecord::Base
  # Inkling:
  include Inkling::Util::Slugs
  acts_as_inkling 'Media'

  # Paperclip:
  has_attached_file :asset,
    :styles => lambda { |attachment| styles_for_attachment(attachment) },
    :path => ':rails_root/public/media/:attachment/:id/:style/:filename',
    :url => '/media/:attachment/:id/:style/:filename'

  # Pagination:
  cattr_reader :per_page
  @@per_page = 10

  belongs_to :user, :class_name => "Inkling::User", :foreign_key => "user_id"

  validates_presence_of :user
  validates_presence_of :title
  def generate_path_slug
    "/media/#{sluggerize(self.title)}"
  end

  # Don't blow up trying to thumbnail some attachment types:
  def self.styles_for_attachment(attachment)
    case attachment.content_type
    when /application\/octet-stream/, /application\/msword/
      {}
    else
      { :medium => "300x300>", :thumb => "100x100>" }
    end
  end
end
