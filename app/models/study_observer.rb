require 'archive'

class StudyObserver < ActiveRecord::Observer
   # include ActionController::UrlWriter
   include Rails.application.routes.url_helpers
   
  def after_create(study)
    log("created", study) if study.created_at == study.updated_at
  end

  def after_save(study)
    log("edited", study) if study.created_at != study.updated_at
  end
  
  def after_destroy(study)
    log("deleted", study)    
  end
  
  private
  def log(verb, study)
    if study.archive
      Inkling::Log.create!(:text => "System #{verb} study <a href='#{edit_staff_study_path(study, :archive_id => study.archive.id)}'>#{study.title}</a> in <a href='/staff/archives/#{study.archive.slug}'>#{study.archive.name}</a>.",
       :category => "content")
    else
      Inkling::Log.create!(:text => "System #{verb} study <a href='#{edit_staff_study_path(study)}'>#{study.title}</a> in <a href='/staff/archives/ada'>ADA</a>.", :category => "content")
    end
  end
end