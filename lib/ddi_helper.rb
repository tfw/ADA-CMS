module DdiHelper  
  def render_ddi_mapping(ddi_field)
    if @mappings.nil?
      @mappings = YAML.load_file("config/ddi_mappings.yml")
    end

    human_readable = @mappings[ddi_field.to_sym]
    human_readable ||= ddi_field if human_readable.nil?
    human_readable
  end

  def ddi_mappings
    if @mappings.nil?
      @mappings = YAML.load_file("config/ddi_mappings.yml")
    end
    @mappings
  end
end
