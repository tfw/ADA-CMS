class DdiMapping < ActiveRecord::Base

  validates_uniqueness_of :ddi 

  def self.batch_create(local_data)
    local_data.each do |k,v|
      if DdiMapping.find_by_ddi(k.to_s).nil?
        mapping = DdiMapping.new(:ddi => k.to_s)
        mapping.save
      end
    end
    #create_or_update_entry(ds, k.to_s, v)}
  end

  def self.human_readable(key)
    mapping = DdiMapping.find_by_ddi(key)
    mapping.human_readable if mapping
  end

  def friendly_name
    if self.ddi =~ /_attribute/
      bits = self.ddi.split("_")
      return "<#{bits[0]} ... #{bits[2]}=''>"
    end
    self.ddi.to_s
  end
  
  def to_s
    human_readable
  end
end
