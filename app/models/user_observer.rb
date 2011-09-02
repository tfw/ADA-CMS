class UserObserver < ActiveRecord::Observer
   include Rails.application.routes.url_helpers
  
  def after_create(user)
    Inkling::Log.create!(:text => "<a href='/staff/users/#{user.id}'>#{user}</a> entered for the first time.", :category => "users", :user_id => user.id)
  end

  def self.re_enters(user)
    Inkling::Log.create!(:text => "<a href='/staff/users/#{user.id}'>#{user}</a> signed in.", :category => "users", :user_id => user.id)
  end

  def self.record_time_and_ip(u)
    now = Time.now
    u.sign_in_count = 0 if u.sign_in_count.nil?
    u.sign_in_count += 1
    u.last_sign_in_at = u.current_sign_in_at
    u.current_sign_in_at = now
    u.last_sign_in_ip = u.current_sign_in_ip
    u.current_sign_in_ip = "127.0.0.1"
    u.save
  end
end
