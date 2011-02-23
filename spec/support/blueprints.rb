require 'machinist/active_record'
require 'sham'
require 'faker'

# a machinist config for quick data generation
Sham.created_at { (0..60).to_a.rand.days.ago }
Sham.body       { Faker::Lorem.sentence }
Sham.reason     { Faker::Lorem.sentence }
Sham.name       { Faker::Lorem.sentence }
Sham.email      { Faker::Internet.email }
# Sham.email      {"somebody#{Time.now.to_i}@anu.edu.au" }
Sham.title      { Faker::Lorem.words(2).to_s }
Sham.word       { Faker::Lorem.words(1).to_s }
Sham.description  { Faker::Lorem.sentence }
Sham.body       { Faker::Lorem.paragraph }
Sham.url        { "http://" + Faker::Internet.domain_name.to_s  }
Sham.display_from { (0..60).to_a.rand.days.ago }
Sham.display_to   { (0..60).to_a.rand.days.since }
Sham.keywords   { Faker::Lorem.sentence }

Inkling::User.blueprint do 
  # email "somebody#{Time.now.to_i}@anu.edu.au"
  email Sham.email
  password 'test123'
  password_confirmation  'test123'
end

Inkling::Role.blueprint do
  name Sham.name
end

Inkling::Role.blueprint(:admin) do
  name "administrator"
end

Inkling::RoleMembership.blueprint do 
  role
  user
end

def make_user(role_name)
  role_name = role_name.to_s if role_name.is_a? Symbol
  role = Inkling::Role.find_by_name(role_name)  
  
  if role.nil?
    role = Inkling::Role.new(:name => role_name)
    role.save!
  end
  
  role_entry = Inkling::RoleMembership.find_by_role_id(role.id)

  unless role_entry
    user = Inkling::User.make
    role_membership = Inkling::RoleMembership.create(:role => role, :user => user) 
  end

  role.users.first
end

Page.blueprint do 
  title Sham.name
  author {(Inkling::User.make)}
  author_id {(Inkling::User.make).id}
  archive {Archive.make}
  link_title Sham.title
  description Sham.description
  body Sham.body
end

Archive.blueprint do 
  name Sham.name
end

Study.blueprint do
  label Sham.name
end