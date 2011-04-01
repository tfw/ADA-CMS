class VariableField < ActiveRecord::Base
  
  belongs_to :variable
  
  def self.to_hash(variable)
    variable_fields = VariableField.find_all_by_variable_id(variable.id)
    
    fields = {}
    
    for field in variable_fields
      fields[field.key] = field.value
    end
    
    fields
  end
  
  def self.create_or_update(key, value, variable)
    begin
      entry = VariableField.find_by_variable_id_and_key(variable.id,key)
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
