# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

["Manager", "Approver", "Archivist", "Member"].each do |role_name| 
  Inkling::Role.create!(:name => role_name) if Inkling::Role.find_by_name(role_name).nil?
end

["Social Science", "Historical", "Indigenous", "Longitudinal", "Qualitative", "International"].each do |archive_name|
  Archive.create!(:name => archive_name) if Archive.find_by_name(archive_name).nil?
end