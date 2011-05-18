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

User.blueprint do 
  identity_url Sham.word
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

ArchiveStudy.blueprint do
  archive
  study
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
    user = User.make
    role_membership = Inkling::RoleMembership.create(:role => role, :user => user) 
  end

  role.users.first
end

Page.blueprint do 
  title Sham.name
  author {(User.make)}
  author_id {(User.make).id}
  archive {Archive.make}
  link_title Sham.title
  description Sham.description
  body Sham.body
end

ArchiveNews.blueprint do
  # Is this enough? What about :news?
  archive {Archive.make}
end

News.blueprint do
  title Sham.name
  user {(User.make)}
  user_id {(User.make).id}
  body Sham.body
end

def make_news attrs = {}
  archives = attrs.delete(:archives) || 1
  News.make(attrs) do |news|
    archives.times do news.news_archives.make; end
  end
end

Archive.blueprint do 
  name Sham.name
end

Study.blueprint do
  label Sham.name
  ddi_id Sham.name
  abstract Sham.body
end

DdiMapping.blueprint do
  ddi Sham.word
  xml_element true
end
