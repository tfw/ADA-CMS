class PageObserver < ActiveRecord::Observer
   include Rails.application.routes.url_helpers
   
  def after_create(page)
    log("created", page) if page.created_at == page.updated_at
  end

  def after_save(page)
    log("edited", page) if page.created_at != page.updated_at
  end
  
  def after_destroy(page)
    log("deleted", page)    
  end
  
  private
  def log(verb, page)
    if page.archive
      Inkling::Log.create!(:text => "#{page.author.email} #{verb} page <a href='#{edit_staff_archive_page_path(page, :archive_id => page.archive.id)}'>#{page.title}</a> in <a href='/staff/archives/#{page.archive.slug}'>#{page.archive.name}</a>.", :category => "content")
    else
      Inkling::Log.create!(:text => "#{page.author.email} #{verb} page <a href='#{edit_staff_archive_page_path(page)}'>#{page.title}</a> in <a href='/staff/archives/ada'>ADA</a>.", :category => "content")
    end
  end
end