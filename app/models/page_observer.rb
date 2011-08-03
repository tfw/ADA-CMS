class PageObserver < ActiveRecord::Observer
  include Rails.application.routes.url_helpers

  def after_create(page)
    log("created", page) if page.created_at == page.updated_at
  end

  def after_save(page)
    expire_fragment("show-page-#{page.id}")
    log("edited", page) if page.created_at != page.updated_at
  end

  def after_destroy(page)
    log("deleted", page)
  end

  private
  def log(verb, page)
    
    case verb
      when "deleted"
        Inkling::Log.create!(:text => "#{page.author} #{verb} page #{page.title} in <a href='/staff/archives/#{page.archive.slug}'>#{page.archive.name}</a>.", :category => "page", :user => page.author)
      else
        Inkling::Log.create!(:text => "#{page.author} #{verb} page <a href='#{edit_staff_archive_page_path(page.archive, page)}'>#{page.title}</a> in <a href='/staff/archives/#{page.archive.slug}'>#{page.archive.name}</a>.", :category => "page", :user => page.author)
    end    
  end
end
