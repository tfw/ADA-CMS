class PageObserver < ActiveRecord::Observer
   # include ActionController::UrlFor
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
    puts " **** #{url_for page.title} \n\n"
    Inkling::Log.create!(:text => "#{page.author.email} #{verb} page #{url_for page.title}")
  end
end