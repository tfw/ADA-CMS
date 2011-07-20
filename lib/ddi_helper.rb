module DdiHelper  
  def ddi_mapping(ddi_field)
    human_readable = ddi_mappings[ddi_field.to_s]
    human_readable ||= ddi_field
    human_readable
  end

  def ddi_mappings
    if Rails.cache.read("ddi_mappings").nil?
      Rails.cache.write("ddi_mappings", YAML.load_file("config/ddi_mappings.yml"))
    end
    Rails.cache.read("ddi_mappings")    
  end
end
