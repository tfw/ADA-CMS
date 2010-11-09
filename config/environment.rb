# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ada::Application.initialize!

#patch inkling paths to cooperate with archive namespaces
class Inkling::Path < ActiveRecord::Base
  def update_slug!
    if self.parent
      slug = "#{self.parent.slug}/"
    else
      if self.content.archive
        slug = "#{self.content.archive.slug}/"
      else
        slug = "/"
      end
    end
    
    slug += "#{self.content.title}"
    self.slug = sluggerize(slug)
  end
end