# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ada::Application.initialize!

#patch inkling paths to cooperate with archive namespaces
class Inkling::Path < ActiveRecord::Base
  def update_slug!
    if self.parent
      self.slug = "#{self.parent.slug}/"
    else
      if self.content.archive
        self.slug = "#{self.content.archive.slug}/"
      else
        slug = "/"
      end
    end
    
    self.slug += sluggerize(self.content.title)
  end
end