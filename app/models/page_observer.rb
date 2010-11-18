class PageObserver < ActiveRecord::Observer

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
    Inkling::Log.create!(:text => "#{page.author.email} #{verb} page #{page.title}")
  end
end