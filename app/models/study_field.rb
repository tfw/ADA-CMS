class StudyField < ActiveRecord::Base
  
  belongs_to :study
  
  def self.to_hash(study)
    fields = StudyField.find_all_by_study_id(study.id)
    
    fields = {}
    
    for field in fields
      fields[field.key] = field.value
    end
    
    fields
  end
  
  def self.create_or_update(key, value, study)
    begin
      entry = StudyField.find_by_study_id_and_key(study.id,key)
    rescue 
      raise StandardError, caller
    end
  
    if entry
      entry.value = value
    else
      entry = StudyField.new(:key => key, :value => value)
    end
  
    entry.save!    
  end
end
