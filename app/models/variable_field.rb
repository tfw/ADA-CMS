class VariableField < ActiveRecord::Base
  
  belongs_to :variable
  
  def self.to_hash(study)
    variable_fields = VariableField.find_all_by_study_id(study.id)
    
    fields = {}
    
    for field in variable_fields
      fields[field.key] = field.value
    end
    
    fields
  end
  
  def self.create_or_update(key, value, study)
    begin
      entry = VariableField.find_by_study_id_and_key(study.id,key)
    rescue 
      raise StandardError, caller
    end
  
    if entry
      entry.value = value
    else
      entry = VariableField.new(:key => key, :value => value)
    end
  
    entry.save!    
  end
end
