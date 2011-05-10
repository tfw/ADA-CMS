class UserObserver < ActiveRecord::Observer
   include Rails.application.routes.url_helpers
  
  def after_create(user)
    Inkling::Log.create!(:text => "<a href='/staff/users/#{user.id}'>#{user}</a> entered for the first time.", :category => "users", :user_id => user.id)
  end

  def self.re_enters(user)
    Inkling::Log.create!(:text => "<a href='/staff/users/#{user.id}'>#{user}</a> signed in.", :category => "users", :user_id => user.id)
  end
end
