require 'factory_girl/syntax/blueprint'
require 'factory_girl/syntax/make'
require 'factory_girl/syntax/sham'

# a machinist config for quick data generation
Sham.created_at { (0..60).to_a.rand.days.ago }
Sham.body       { Faker::Lorem.sentence }
Sham.reason     { Faker::Lorem.sentence }
Sham.name       { Faker::Lorem.sentence }
Sham.email      { Faker::Internet.email }
Sham.title      { Faker::Lorem.words(2).to_s }
Sham.word       { Faker::Lorem.words(1).to_s }
Sham.description  { Faker::Lorem.sentence }
Sham.body       { Faker::Lorem.paragraph }
Sham.url        { "http://" + Faker::Internet.domain_name.to_s  }
Sham.author_id  { 1 }
Sham.display_from { (0..60).to_a.rand.days.ago }
Sham.display_to   { (0..60).to_a.rand.days.since }
Sham.keywords   { Faker::Lorem.sentence }

Factory.define :user, :class => "Inkling::User" do |f|  
  f.email {Factory.next :email}
  f.password 'test123'
  f.password_confirmation  'test123'
end

Factory.define :role, :class => "Inkling::Role" do |f|
  f.association :name
end

Factory.define :role_membership, :class => "Inkling::RoleMembership" do |f|
  f.association :role
  f.association :user
end

Factory.define :admin_role, :parent => :role do |f|
  f.name Inkling::Role::ADMIN
end

Factory.define :admin_role_membership, :parent => :role_membership do |f|
  f.association :role, :factory => :admin_role
  f.association :user
end

Factory.define :admin_user, :parent => :user do |f|
  f.role_memberships {|memberships| [memberships.association(:admin_role_membership)]}
end

Factory.define :page do |f|
  f.name Sham.name
  # f.author_id Inkling::Role.find_by_name("administrator").users.first.id
  f.association :archive, :factory => :archive 
end

Factory.define :archive do |f|
  f.name Sham.name
end

Factory.sequence :email do |n|
  "person#{n}@anu.edu.au"
end

