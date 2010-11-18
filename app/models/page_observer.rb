class PageObserver < ActiveRecord::Observer
   # include ActionView::Helpers::UrlHelper
   include ActionController::UrlWriter
   include Rails.application.routes.url_helpers
   
  def after_create(page)
    log("created", page)
  end

  def after_save(page)
    log("edited", page)    
  end
  
  def after_destroy(page)
    log("deleted", page)    
  end
  
  private
  def log(verb, page)
    Inkling::Log.create!(:text => "#{page.author.email} #{verb} page <a href='#{edit_staff_page_path(page)}'>page.title</a>")
  end
end