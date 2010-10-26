class DatasetEntry < ActiveRecord::Base
  
  belongs_to :dataset
  
  def self.create_or_update(key, value, dataset)
    begin
      entry = DatasetEntry.find_by_dataset_id_and_key(dataset.id,key)
    rescue 
      raise StandardError, caller
    end
  
    if entry
      entry.value = value
    else
      entry = DatasetEntry.new(:key => key, :value => value)
    end
  
    entry.save!    
  end
end
