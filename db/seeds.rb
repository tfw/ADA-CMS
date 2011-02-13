# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#old seeds, before we adopted the database dump

# if Inkling::Role.find_by_name("administrator").users.empty?
#   puts "Please run `rake inkling:init' first. \n\n"
# end
# 
# #roles
# ["Manager", "Approver", "Archivist", "Member"].each do |role_name| 
#   Inkling::Role.create!(:name => role_name) if Inkling::Role.find_by_name(role_name).nil?
# end
# 
# #archives
# ["ADA", 'Social Science', "Historical", "Indigenous", "Longitudinal", "Qualitative", "International"].each do |archive_name|
#   Archive.create!(:name => archive_name) if Archive.find_by_name(archive_name).nil?
# end
# 
# for archive in Archive.all do
#   home_page = Page.create!(:archive_id => archive.id, :title => "Home", :body => "", :author =>  Inkling::Role.find_by_name("administrator").users.first, :partial => "/pages/home_page") unless Page.find_by_title_and_archive_id("Home", archive.id)
# end

# unless Inkling::User.find_by_email("steven.mceachern@anu.edu.au")
#   user = Inkling::User.create!(:email => "steven.mceachern@anu.edu.au", :password => "adaada", :password_confirmation => "adaada")
#   Inkling::RoleMembership.create!(:user => user, :role => Inkling::Role.find_by_name("Manager"))
# 
#   user = Inkling::User.create!(:email => "deborah.mitchell@anu.edu.au", :password => "adaada", :password_confirmation => "adaada")
#   Inkling::RoleMembership.create!(:user => user, :role => Inkling::Role.find_by_name("Manager"))
# 
#   user = Inkling::User.create!(:email => "ben.evans@anu.edu.au", :password => "adaada", :password_confirmation => "adaada")
#   Inkling::RoleMembership.create!(:user => user, :role => Inkling::Role.find_by_name("Manager"))
# 
#   user = Inkling::User.create!(:email => "paul.kuske@anu.edu.au", :password => "adaada", :password_confirmation => "adaada")
#   Inkling::RoleMembership.create!(:user => user, :role => Inkling::Role.find_by_name("Manager"))
# end

archive = Archive.create(:name => "ADA") if Archive.find_by_name("ADA").nil?

for page in Page.find_all_by_archive_id(nil)
  page.archive_id = archive
end

