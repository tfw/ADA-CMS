class UserObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers

  def after_create(user)
    Inkling::Log.create!(:text => "#{user.email} (firstname surname combo needs to be sent from ADA Users) entered for the first time.", :category => "users", :user_id => user.id)
  end

  def self.re_enters(user)
    Inkling::Log.create!(:text => "#{user.email}  (firstname surname combo needs to be sent from ADA Users) signed in.", :category => "users", :user_id => user.id)
  end
end
