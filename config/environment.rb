# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ada::Application.initialize!

# #patch inkling paths to cooperate with archive namespaces
# class Inkling::Path < ActiveRecord::Base
#   def update_slug!
#     slug = self.parent ? "#{self.parent.slug}/" : "/"
#     slug += "#{self.content.name}"
#     self.slug = sluggerize(slug)
#   end
#   
#   def slug_unique?
#     pre_existing = Inkling::Path.find_by_slug(self.slug)
# 
#     if pre_existing and (self.new_record? or (pre_existing.id != self.id))
#       self.errors.add("path (#{self.slug}) already taken by another object in this website ")
#     end
#   end
# end