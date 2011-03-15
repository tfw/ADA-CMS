class Media < ActiveRecord::Base
  # Inkling:
  include Inkling::Util::Slugs
  acts_as_inkling 'Media'

  # Paperclip:
  has_attached_file :asset,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
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
end
