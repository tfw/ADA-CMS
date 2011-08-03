require 'archive'

class VariableObserver < ActiveRecord::Observer
  # def after_save(study)
  #   expire_fragment("show-study-#{study.id}")
  # end
end