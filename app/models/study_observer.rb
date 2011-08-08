require 'archive'

class StudyObserver < ActiveRecord::Observer
   include Rails.application.routes.url_helpers
   
  def after_create(study)
    log("created", study) if study.created_at == study.updated_at
  end

  def after_save(study)
    ActionController::Base.new.expire_fragment("show-study-#{study.id}")
    log("edited", study) if study.created_at != study.updated_at
  end
  
  def after_destroy(study)
    ActionController::Base.new.expire_fragment("show-study-#{study.id}")
    log("deleted", study)    
  end
  
  private
  def log(verb, study)
    Inkling::Log.create!(:text => "System #{verb} study #{study.title} in <a href='/staff/archives/ada'>ADA</a>.", :category => "content")
  end
end